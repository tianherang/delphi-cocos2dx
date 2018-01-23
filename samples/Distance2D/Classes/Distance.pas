unit Distance;

interface
uses
  box2d.b2Settings, box2d.b2Math;

const e_maxSimplices = 20;

type
  PPolygon = ^Polygon;
  Polygon = object
    m_points: pb2Vec2s;
    m_count: int32;
    function GetSupport(const d: b2Vec2): int32;
  end;

  PSimplexVertexs = ^SimplexVertexs;
  PSimplexVertex = ^SimplexVertex;
  SimplexVertex = record
    point1: b2Vec2;
    point2: b2Vec2;
    point: b2Vec2;
    u: float32;
    index1: int32;
    index2: int32;
  end;
  SimplexVertexs = array [0..MaxInt div SizeOf(SimplexVertex) - 1] of SimplexVertex;

  Simplex = object
    m_vertexA, m_vertexB, m_vertexC: SimplexVertex;
    m_divisor: float32;
    m_count: int32;
    function GetSearchDirection(): b2Vec2;
    function GetClosestPoint(): b2Vec2;
    procedure GetWitnessPoints(point1, point2: pb2Vec2);
    procedure Solve2(const Q: b2Vec2);
    procedure Solve3(const Q: b2Vec2);
  end;

  PInput = ^Input;
  Input = record
    polygon1: Polygon;
    polygon2: Polygon;
    transform1: Transform;
    transform2: Transform;
  end;

  POutput = ^Output;
  Output = record
    point1, point2: b2Vec2;
    distance: float32;
    iterations: int32;
    simplices: array [0..e_maxSimplices-1] of Simplex;
    simplexCount: int32;
  end;

procedure Distance2D(output: POutput; const input: PInput);

implementation

procedure Distance2D(output: POutput; const input: PInput);
const k_maxIters = 20;
var
  polygon1, polygon2: PPolygon;
  transform1, transform2: Transform;
  simple: Simplex;
  localPoint1, localPoint2, d: b2Vec2;
  vertex: PSimplexVertex;
  vertices: PSimplexVertexs;
  save1, save2: array [0..2] of Integer;
  saveCount, iter: Integer;
  duplicate: Boolean;
  i: Integer;
begin
  polygon1 := @input.polygon1;
  polygon2 := @input.polygon2;

  transform1 := input.transform1;
  transform2 := input.transform2;

  simple.m_vertexA.index1 := 0;
  simple.m_vertexA.index2 := 0;
  localPoint1 := polygon1^.m_points[0];
  localPoint2 := polygon2^.m_points[0];
  simple.m_vertexA.point1 := b2Mul(transform1, localPoint1);
  simple.m_vertexA.point2 := b2Mul(transform2, localPoint2);
  simple.m_vertexA.point := b2Vec2Sub(simple.m_vertexA.point2, simple.m_vertexA.point1);
  simple.m_vertexA.u := 1.0;
  simple.m_vertexA.index1 := 0;
  simple.m_vertexA.index2 := 0;
  simple.m_count := 1;

  output^.simplexCount := 0;

  vertices := @simple.m_vertexA;
  //saveCount := 0;

  iter := 0;
  while iter < k_maxIters do
  begin
    saveCount := simple.m_count;
    for i := 0 to saveCount-1 do
    begin
      save1[i] := vertices[i].index1;
      save2[i] := vertices[i].index2;
    end;

    case simple.m_count of
      1:
      begin

      end;
      2:
      begin
        simple.Solve2(b2Vec2_zero);
      end;
      3:
      begin
        simple.Solve3(b2Vec2_zero);
      end;
    else
      begin

      end;
    end;

    output^.simplices[output^.simplexCount] := simple;
    Inc(output^.simplexCount);

    if simple.m_count = 3 then
      Break;

    d := simple.GetSearchDirection();

    if b2Dot(d, d) = 0.0 then
      Break;

    vertex := @vertices[simple.m_count];
    vertex^.index1 := polygon1.GetSupport(b2Mult(transform1.R, d.Neg()));
    vertex^.point1 := b2Mul(transform1, polygon1.m_points[vertex^.index1]);
    vertex^.index2 := polygon2.GetSupport(b2Mult(transform2.R, d.Neg()));
    vertex^.point2 := b2Mul(transform2, polygon2.m_points[vertex^.index2]);
    vertex^.point := b2Vec2Sub(vertex^.point2, vertex^.point1);

    Inc(iter);

    duplicate := False;
    for i := 0 to saveCount-1 do
    begin
      if (vertex^.index1 = save1[i]) and (vertex^.index2 = save2[i]) then
      begin
        duplicate := True;
        Break;
      end;  
    end;

    if duplicate then
      Break;

    Inc(simple.m_count);
  end;

  simple.GetWitnessPoints(@output^.point1, @output^.point2);
  output.distance := b2Distance(output^.point1, output^.point2);
  output^.iterations := iter;
end;

{ Polygon }

function Polygon.GetSupport(const d: b2Vec2): int32;
var
  bestIndex, i: Integer;
  bestValue, value: float32;
begin
  bestIndex := 0;
  bestValue := b2Dot(m_points[0], d);
  for i := 1 to m_count-1 do
  begin
    value := b2Dot(m_points[i], d);
    if value > bestValue then
    begin
      bestIndex := i;
      bestValue := value;
    end;
  end;
  Result := bestIndex;
end;

{ Simplex }

function Simplex.GetClosestPoint: b2Vec2;
var
  s: float32;
begin
  case m_count of
    1:
    begin
      Result := m_vertexA.point;
    end;
    2:
    begin
      s := 1.0 / m_divisor;
      Result := b2Vec2Add(b2Vec2Mul(s * m_vertexA.u, m_vertexA.point), b2Vec2Mul(s * m_vertexB.u, m_vertexB.point));
    end;
    3:
    begin
      Result := b2Vec2_zero;
    end;
  else
    begin
      Result := b2Vec2_zero;
    end;  
  end;
end;

function Simplex.GetSearchDirection: b2Vec2;
var
  edgeAB: b2Vec2;
  sgn: float32;
begin
  case m_count of
    1:
    begin
      Result := m_vertexA.point.Neg();
    end;
    2:
    begin
      edgeAB := b2Vec2Sub(m_vertexB.point, m_vertexA.point);
      sgn := b2Cross(edgeAB, m_vertexA.point.Neg());
      if sgn > 0.0 then
      begin
        Result := b2Cross(1.0, edgeAB);
      end else
      begin
        Result := b2Cross(edgeAB, 1.0);
      end;
    end;
  else
    begin
      Result := b2Vec2_zero;
    end;  
  end;
end;

procedure Simplex.GetWitnessPoints(point1, point2: pb2Vec2);
var
  //factor,
  s: float32;
  v: b2Vec2;
begin
  //factor := 1.0 / m_divisor;
  case m_count of
    1:
    begin
      point1^ := m_vertexA.point1;
      point2^ := m_vertexA.point2;
    end;
    2:
    begin
      s := 1.0 / m_divisor;
      point1^ := b2Vec2Add( b2Vec2Mul(s * m_vertexA.u, m_vertexA.point1), b2Vec2Mul(s * m_vertexB.u, m_vertexB.point1));
      point2^ := b2Vec2Add( b2Vec2Mul(s * m_vertexA.u, m_vertexA.point2), b2Vec2Mul(s * m_vertexB.u, m_vertexB.point2));
    end;
    3:
    begin
      s := 1.0 / m_divisor;
      v := b2Vec2Add( b2Vec2Mul(s * m_vertexA.u, m_vertexA.point1), b2Vec2Mul(s * m_vertexB.u, m_vertexB.point1));
      point1^ := b2Vec2Add(v, b2Vec2Mul(s * m_vertexC.u, m_vertexC.point1));
      point2^ := point1^;
    end;
  end;
end;

procedure Simplex.Solve2(const Q: b2Vec2);
var
  A, B, e: b2Vec2;
  u, v: float32;
begin
  A := m_vertexA.point;
  B := m_vertexB.point;
  u := b2Dot(b2Vec2Sub(Q, B), b2Vec2Sub(A, B));
  v := b2Dot(b2Vec2Sub(Q, A), b2Vec2Sub(B, A));

  if v <= 0.0 then
  begin
    m_vertexA.u := 1.0;
    m_divisor := 1.0;
    m_count := 1;
    Exit;
  end;

  if u <= 0.0 then
  begin
    m_vertexA := m_vertexB;
    m_vertexA.u := 1.0;
    m_divisor := 1.0;
    m_count := 1;
    Exit;
  end;

  m_vertexA.u := u;
  m_vertexB.u := v;
  e := b2Vec2Sub(B, A);
  m_divisor := b2Dot(e, e);
  m_count := 2;
end;

procedure Simplex.Solve3(const Q: b2Vec2);
var
  A, B, C, e: b2Vec2;
  uAB, vAB, uBC, vBC, uCA, vCA: float32;
  area, uABC, vABC, wABC: float32;
begin
  A := m_vertexA.point;
  B := m_vertexB.point;
  C := m_vertexC.point;

  uAB := b2Dot(b2Vec2Sub(Q, B), b2Vec2Sub(A, B));
  vAB := b2Dot(b2Vec2Sub(Q, A), b2Vec2Sub(B, A));

  uBC := b2Dot(b2Vec2Sub(Q, C), b2Vec2Sub(B, C));
  vBC := b2Dot(b2Vec2Sub(Q, B), b2Vec2Sub(C, B));

  uCA := b2Dot(b2Vec2Sub(Q, A), b2Vec2Sub(C, A));
  vCA := b2Dot(b2Vec2Sub(Q, C), b2Vec2Sub(A, C));

  if (vAB <= 0.0) and (uCA <= 0.0) then
  begin
    m_vertexA.u := 1.0;
    m_divisor := 1.0;
    m_count := 1;
    Exit;
  end;

  if (uAB <= 0.0) and (vBC <= 0.0) then
  begin
    m_vertexA := m_vertexB;
    m_vertexA.u := 1.0;
    m_divisor := 1.0;
    m_count := 1;
    Exit;
  end;

  if (uBC <= 0.0) and (vCA <= 0.0) then
  begin
    m_vertexA := m_vertexC;
    m_vertexA.u := 1.0;
    m_divisor := 1.0;
    m_count := 1;
    Exit;
  end;

  area := b2Cross(b2Vec2Sub(B, A), b2Vec2Sub(C, A));

  uABC := b2Cross(b2Vec2Sub(B, Q), b2Vec2Sub(C, Q));
  vABC := b2Cross(b2Vec2Sub(C, Q), b2Vec2Sub(A, Q));
  wABC := b2Cross(b2Vec2Sub(A, Q), b2Vec2Sub(B, Q));

  if (uAB > 0.0) and (vAB > 0.0) and (wABC * area <= 0.0) then
  begin
    m_vertexA.u := uAB;
    m_vertexB.u := vAB;
    e := b2Vec2Sub(B, A);
    m_divisor := b2Dot(e, e);
    m_count := 2;
    Exit;
  end;

  if (uBC > 0.0) and (vBC > 0.0) and (uABC * area <= 0.0) then
  begin
    m_vertexA := m_vertexB;
    m_vertexB := m_vertexC;

    m_vertexA.u := uBC;
    m_vertexB.u := vBC;
    e := b2Vec2Sub(C, B);
    m_divisor := b2Dot(e, e);
    m_count := 2;
    Exit;
  end;

  if (uCA > 0.0) and (vCA > 0.0) and (vABC * area <= 0.0) then
  begin
    m_vertexB := m_vertexA;
    m_vertexA := m_vertexC;

    m_vertexA.u := uCA;
    m_vertexB.u := vCA;
    e := b2Vec2Sub(A, C);
    m_divisor := b2Dot(e, e);
    m_count := 2;
    Exit;
  end;

  m_vertexA.u := uABC;
  m_vertexB.u := vABC;
  m_vertexC.u := wABC;
  m_divisor := area;
  m_count := 3;
end;

end.
