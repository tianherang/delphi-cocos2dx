unit box2d.b2Math;

interface
uses
  Math,
  box2d.b2Settings;

function b2IsValid(x: float32): Boolean;
function b2InvSqrt(x: float32): float32;

type
  pb2Vec2s = ^b2Vec2s;
  pb2Vec2 = ^b2Vec2;
  b2Vec2 = object
    x, y: float32;
    procedure b2Vec2(x_, y_: float32);
    procedure SetZero();
    procedure SetValue(x_, y_: float32);
    function Neg(): b2Vec2;
    function Item(i: int32): float32;
    function ItemA(i: int32): pfloat32;
    procedure Add(const v: b2Vec2);
    procedure Sub(const v: b2Vec2);
    procedure Mul(a: float32);
    function Length(): float32;
    function LengthSquared(): float32;
    function Normalize(): float32;
    function IsValid(): Boolean;
    function IsEqual(const v: b2Vec2): Boolean;
    function Skew(): b2Vec2;
  end;
  b2Vec2s = array [0..MaxInt div SizeOf(b2Vec2) - 1] of b2Vec2;

  b2Vec3 = object
    x, y, z: float32;
    procedure b2Vec3(x_, y_, z_: float32);
    procedure SetZero();
    procedure SetValue(x_, y_, z_: float32);
    function Neg(): b2Vec3;
    procedure Add(const v: b2Vec3);
    procedure Sub(const v: b2Vec3);
    procedure Mul(const s: float32);
  end;

  b2Mat22 = object
    ex, ey: b2Vec2;
    procedure b2Mat22(const c1, c2: b2Vec2); overload;
    procedure b2Mat22(a11, a12, a21, a22: float32); overload;
    procedure SetValue(const c1, c2: b2Vec2); overload;
    procedure SetValue(angle: float32); overload;
    procedure SetIdentity();
    procedure SetZero();
    function GetInverse(): b2Mat22;
    function Solve(const b: b2Vec2): b2Vec2;
  end;

  pb2Mat33 = ^b2Mat33;
  b2Mat33 = object
    ex, ey, ez: b2Vec3;
    procedure b2Mat33(const c1, c2, c3: b2Vec3);
    procedure SetZero();
    function Solve33(const b: b2Vec3): b2Vec3;
    function Solve22(const b: b2Vec2): b2Vec2;
    procedure GetInverse22(M: pb2Mat33);
    procedure GetSymInverse33(M: pb2Mat33);
  end;

  b2Rot = object
    s, c: float32;
    procedure b2Rot(angle: float32);
    procedure SetValue(angle: float32);
    procedure SetIdentity();
    function GetAngle(): float32;
    function GetXAxis(): b2Vec2;
    function GetYAxis(): b2Vec2;
  end;

  pb2Transform = ^b2Transform;
  b2Transform = object
    p: b2Vec2;
    q: b2Rot;
    procedure b2Transform(const position: b2Vec2; const rotation: b2Rot);
    procedure SetIdentity();
    procedure SetValue(const position: b2Vec2; angle: float32);
  end;

  Transform = record
    R: b2Mat22;
    P: b2Vec2;
  end;

  b2Sweep = object
    localCenter: b2Vec2;
    c0, c: b2Vec2;
    a0, a: float32;
    alpha0: float32;
    procedure GetTransform(xf: pb2Transform; beta: float32);
    procedure Advance(alpha: float32);
    procedure Normalize();
  end;

function b2Dot(const a, b: b2Vec2): float32; overload;
function b2Cross(const a, b: b2Vec2): float32; overload;
function b2Cross(const a: b2Vec2; s: float32): b2Vec2; overload;
function b2Cross(s: float32; const a: b2Vec2): b2Vec2; overload;
function b2Mul(const A: b2Mat22; const v: b2Vec2): b2Vec2; overload;
function b2Mult(const A: b2Mat22; const v: b2Vec2): b2Vec2; overload;
function b2Vec2Add(const a, b: b2Vec2): b2Vec2;
function b2Vec2Sub(const a, b: b2Vec2): b2Vec2;
function b2Vec2Mul(s: float32; const a: b2Vec2): b2Vec2;
function b2Vec2Equal(const a, b: b2Vec2): Boolean;
function b2Distance(const a, b: b2Vec2): float32;
function b2DistanceSquared(const a, b: b2Vec2): float32; overload;
function b2Vec3Mul(s: float32; const a: b2Vec3): b2Vec3;
function b2Vec3Add(const a, b: b2Vec3): b2Vec3;
function b2Vec3Sub(const a, b: b2Vec3): b2Vec3;
function b2Dot(const a, b: b2Vec3): float32; overload;
function b2Cross(const a, b: b2Vec3): b2Vec3; overload;
function b2Mat22Add(const A, B: b2Mat22): b2Mat22;
function b2Mul(const A, B: b2Mat22): b2Mat22; overload;
function b2Mult(const A, B: b2Mat22): b2Mat22; overload;
function b2Mul(const A: b2Mat33; const v: b2Vec3): b2Vec3; overload;
function b2Mul22(const A: b2Mat33; const v: b2Vec2): b2Vec2;
function b2Mul(const q, r: b2Rot): b2Rot; overload;
function b2Mult(const q, r: b2Rot): b2Rot; overload;
function b2Mul(const q: b2Rot; const v: b2Vec2): b2Vec2; overload;
function b2Mult(const q: b2Rot; const v: b2Vec2): b2Vec2; overload;
function b2Mul(const T: b2Transform; const v: b2Vec2): b2Vec2; overload;
function b2Mult(const T: b2Transform; const v: b2Vec2): b2Vec2; overload;
function b2Mul(const A, B: b2Transform): b2Transform; overload;
function b2Mult(const A, B: b2Transform): b2Transform; overload;
function b2NextPowerOfTwo(x: uint32): uint32;
function b2IsPowerOfTwo(x: uint32): Boolean;
function b2Abs(const a: b2Vec2): b2Vec2; overload;
function b2Abs(const A: b2Mat22): b2Mat22; overload;
function b2Min(const a, b: b2Vec2): b2Vec2;
function b2Max(const a, b: b2Vec2): b2Vec2;
function b2Clamp(a, low, high: float32): float32; overload;
function b2Clamp(a, low, high: b2Vec2): b2Vec2; overload;
function MakeVector(x, y: float32): b2Vec2;
function b2Mul(const T: Transform; const v: b2Vec2): b2Vec2; overload;

var b2Vec2_zero: b2Vec2 = (x: 0.0; y: 0.0);

implementation

function b2IsValid(x: float32): Boolean;
var
  ix: int32;
begin
  ix := pint32(@x)^;
  Result := ix and $7f800000 <> $7f800000;
end;

type
  convert = record
  case Integer of
    0: (x: float32);
    1: (i: int32);
  end;

function b2InvSqrt(x: float32): float32;
var
  cov: convert;
  xhalf: float32;
begin
  cov.x := x;
  xhalf := 0.5 * x;
  cov.i := $5f3759df - cov.i shr 1;
  x := cov.x;
  x := x * (1.5 - xhalf * x * x);
  Result := x;
end;

{ b2Vec2 }

procedure b2Vec2.Add(const v: b2Vec2);
begin
  x := x + v.x;
  y := y + v.y;
end;

procedure b2Vec2.b2Vec2(x_, y_: float32);
begin
  x := x_;
  y := y_;
end;

function b2Vec2.IsValid: Boolean;
begin
  Result := b2IsValid(x) and b2IsValid(y);
end;

function b2Vec2.Item(i: int32): float32;
begin
  Result := pfloat32(Integer(@x) + i * SizeOf(float32))^;
end;

function b2Vec2.Length: float32;
begin
  Result := Sqrt(x * x + y * y);
end;

function b2Vec2.LengthSquared: float32;
begin
  Result := x * x + y * y;
end;

procedure b2Vec2.Mul(a: float32);
begin
  x := x * a;
  y := y * a;
end;

function b2Vec2.Neg: b2Vec2;
begin
  Result.x := -x;
  Result.y := -y;
end;

function b2Vec2.Normalize: float32;
var
  len, invLen: float32;
begin
  len := Length();
  if len < b2_epsilon then
  begin
    Result := 0.0;
    Exit;
  end;
  invLen := 1.0 / len;
  x := x * invLen;
  y := y * invLen;
  Result := len;
end;

procedure b2Vec2.SetValue(x_, y_: float32);
begin
  x := x_;
  y := y_;
end;

procedure b2Vec2.SetZero;
begin
  x := 0.0;
  y := 0.0;
end;

function b2Vec2.Skew: b2Vec2;
begin
  Result.x := -y;
  Result.y := x;
end;

procedure b2Vec2.Sub(const v: b2Vec2);
begin
  x := x - v.x;
  y := y - v.y;
end;

function b2Vec2.ItemA(i: int32): pfloat32;
begin
  Result := pfloat32(int32(@x) + i * SizeOf(float32));
end;

function b2Vec2.IsEqual(const v: b2Vec2): Boolean;
begin
  Result := (x = v.x) and (y = v.y);  
end;

{ b2Vec3 }

procedure b2Vec3.Add(const v: b2Vec3);
begin
  x := x + v.x;
  y := y + v.y;
  z := z + v.z;
end;

procedure b2Vec3.b2Vec3(x_, y_, z_: float32);
begin
  x := x_;
  y := y_;
  z := z_;
end;

procedure b2Vec3.Mul(const s: float32);
begin
  x := x * s;
  y := y * s;
  z := z * s;
end;

function b2Vec3.Neg: b2Vec3;
begin
  Result.x := -x;
  Result.y := -y;
  Result.z := -z;
end;

procedure b2Vec3.SetValue(x_, y_, z_: float32);
begin
  x := x_;
  y := y_;
  z := z_;
end;

procedure b2Vec3.SetZero;
begin
  x := 0.0;
  y := 0.0;
  z := 0.0;
end;

procedure b2Vec3.Sub(const v: b2Vec3);
begin
  x := x - v.x;
  y := y - v.y;
  z := z - v.z;
end;

{ b2Mat22 }

procedure b2Mat22.b2Mat22(a11, a12, a21, a22: float32);
begin
  ex.x := a11; ex.y := a21;
  ey.x := a12; ey.y := a22;
end;

procedure b2Mat22.b2Mat22(const c1, c2: b2Vec2);
begin
  ex := c1;
  ey := c2;
end;

function b2Mat22.GetInverse: b2Mat22;
var
  a, b, c, d: float32;
  det: float32;
begin
  a := ex.x; b := ey.x; c := ex.y; d := ey.y;
  det := a * d - b * c;
  if det <> 0.0 then
    det := 1.0 / det;
  Result.ex.x :=  det * d; Result.ey.x := -det * b;
  Result.ex.y := -det * c; Result.ey.y :=  det * a;
end;

procedure b2Mat22.SetValue(const c1, c2: b2Vec2);
begin
  ex := c1;
  ey := c2;
end;

procedure b2Mat22.SetIdentity;
begin
  ex.x := 1.0; ey.x := 0.0;
  ex.y := 0.0; ey.y := 1.0;
end;

procedure b2Mat22.SetZero;
begin
  ex.x := 0.0; ey.x := 0.0;
  ex.y := 0.0; ey.y := 0.0;
end;

/// Solve A * x = b, where b is a column vector. This is more efficient
/// than computing the inverse in one-shot cases.
function b2Mat22.Solve(const b: b2Vec2): b2Vec2;
var
  a11, a12, a21, a22, det: float32;
begin
  a11 := ex.x; a12 := ey.x; a21 := ex.y; a22 := ey.y;
  det := a11 * a22 - a12 * a21;
  if det <> 0.0 then
    det := 1.0 / det;
  Result.x := det * (a22 * b.x - a12 * b.y);
  Result.y := det * (a11 * b.y - a21 * b.x);
end;

procedure b2Mat22.SetValue(angle: float32);
var
  c, s: float32;
begin
  c := Cos(angle);
  s := Sin(angle);
  ex.x := c; ey.x := -s;
  ex.y := s; ey.y := c;  
end;

{ b2Mat33 }

procedure b2Mat33.b2Mat33(const c1, c2, c3: b2Vec3);
begin
  ex := c1;
  ey := c2;
  ez := c3;
end;

procedure b2Mat33.GetInverse22(M: pb2Mat33);
var
  a, b, c, d, det: float32;
begin
  a := ex.x; b := ey.x; c := ex.y; d := ey.y;
  det := a * d - b * c;
  if det <> 0.0 then
    det := 1.0 / det;

  M^.ex.x :=  det * d;	M^.ey.x := -det * b; M^.ex.z := 0.0;
	M^.ex.y := -det * c;	M^.ey.y :=  det * a; M^.ey.z := 0.0;
	M^.ez.x := 0.0;       M^.ez.y := 0.0;      M^.ez.z := 0.0;
end;

procedure b2Mat33.GetSymInverse33(M: pb2Mat33);
var
  det: float32;
  a11, a12, a13, a22, a23, a33: float32;
begin
  det := b2Dot(ex, b2Cross(ey, ez));
  if det <> 0.0 then
    det := 1.0 / det;
  a11 := ex.x; a12 := ey.x; a13 := ez.x;
  a22 := ey.y; a23 := ez.y;
  a33 := ez.z;

  M^.ex.x := det * (a22 * a33 - a23 * a23);
	M^.ex.y := det * (a13 * a23 - a12 * a33);
	M^.ex.z := det * (a12 * a23 - a13 * a22);

	M^.ey.x := M^.ex.y;
	M^.ey.y := det * (a11 * a33 - a13 * a13);
	M^.ey.z := det * (a13 * a12 - a11 * a23);

	M^.ez.x := M^.ex.z;
	M^.ez.y := M^.ey.z;
	M^.ez.z := det * (a11 * a22 - a12 * a12);
end;

procedure b2Mat33.SetZero;
begin
  ex.SetZero();
  ey.SetZero();
  ez.SetZero();
end;

function b2Mat33.Solve22(const b: b2Vec2): b2Vec2;
var
  a11, a12, a21, a22: float32;
  det: float32;
begin
  a11 := ex.x; a12 := ey.x; a21 := ex.y; a22 := ey.y;
  det := a11 * a22 - a12 * a21;
  if det <> 0.0 then
    det := 1.0 / det;
  Result.x := det * (a22 * b.x - a12 * b.y);
  Result.y := det * (a11 * b.y - a21 * b.x);
end;

function b2Mat33.Solve33(const b: b2Vec3): b2Vec3;
var
  det: float32;
begin
  det := b2Dot(ex, b2Cross(ey, ez));
  if det <> 0.0 then
    det := 1.0 / det;
  Result.x := det * b2Dot(b, b2Cross(ey, ez));
  Result.y := det * b2Dot(ex, b2Cross(b, ez));
  Result.z := det * b2Dot(ex, b2Cross(ey, b));
end;

{ b2Rot }

procedure b2Rot.b2Rot(angle: float32);
begin
  s := Sin(angle);
  c := Cos(angle);
end;

/// Get the angle in radians
function b2Rot.GetAngle: float32;
begin
  Result := ArcTan2(s, c);
end;

function b2Rot.GetXAxis: b2Vec2;
begin
  Result.SetValue(c, s);
end;

function b2Rot.GetYAxis: b2Vec2;
begin
  Result.SetValue(-s, c);
end;

procedure b2Rot.SetValue(angle: float32);
begin
  s := Sin(angle);
  c := Cos(angle);
end;

procedure b2Rot.SetIdentity;
begin
  s := 0.0;
  c := 1.0;
end;

{ b2Transform }

procedure b2Transform.b2Transform(const position: b2Vec2;
  const rotation: b2Rot);
begin
  p := position;
  q := rotation;
end;

procedure b2Transform.SetValue(const position: b2Vec2; angle: float32);
begin
  p := position;
  q.SetValue(angle);
end;

procedure b2Transform.SetIdentity;
begin
  p.SetZero();
  q.SetIdentity();
end;

{ b2Sweep }

procedure b2Sweep.Advance(alpha: float32);
var
  beta: float32;
begin
  b2Assert(alpha0 < 1.0);
  beta := (alpha - alpha0) / (1.0 - alpha0);
  c0.Add(b2Vec2Mul(beta, b2Vec2Sub(c, c0)));
  a0 := a0 + beta * (a - a0);
  alpha0 := alpha;
end;

procedure b2Sweep.GetTransform(xf: pb2Transform; beta: float32);
var
  angle: float32;
begin
  xf^.p := b2Vec2Add(b2Vec2Mul(1.0 - beta, c0), b2Vec2Mul(beta, c));
  angle := (1.0 - beta) * a0 + beta * a;
  xf^.q.SetValue(angle);
  xf^.p.Sub(b2Mul(xf^.q, localCenter));
end;

procedure b2Sweep.Normalize;
var
  twoPi, d: float32;
begin
  twoPi := 2.0 * b2_pi;
  d := twoPi * Floor(a0 / twoPi);
  a0 := a0 - d;
  a := a - d;
end;

//A.B = |A||B|Cos(θ), θ是向量A和B的夹角，|A|和|B|是向量的长度
//所以如果A.B = 0,那么两个向量互相垂直
//所以Cos(θ) = A.B/|A||B|,通过点乘，很容易得到连个向量之间的夹角

//A.B > 0   0 <= θ< 90     方向基本相同
//A.B = 0   θ<= 90         正交
//A.B < 0   90 < θ<= 180   方向基本相反
function b2Dot(const a, b: b2Vec2): float32; overload;
begin
  Result := a.x * b.x + a.y * b.y;
end;

//叉乘的结果看起来是个标量，事实上叉乘的结果是个向量，结果是它的模。在2维空间中，我们暂时忽略它的方向。
//叉乘在3维空间中才有实际意义 = a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x
//我们可以把2维向量看做Z值为0来推导
//A*B = |A||B|Sin(θ)，这儿的角度和上面的点乘角度有点不同，它是有正负的，是指从A到B的角度
//叉乘的绝对值为向量所形成的平行四边形面积，也就是AB所包围的三角形面积的2倍
function b2Cross(const a, b: b2Vec2): float32; overload;
begin
  Result := a.x * b.y - a.y * b.x;
end;  

//实际上是返回一个和A垂直的缩放的向量
function b2Cross(const a: b2Vec2; s: float32): b2Vec2; overload;
begin
  Result.b2Vec2(s * a.y, -s * a.x);
end;  

//和上个函数返回的向量方向相反
function b2Cross(s: float32; const a: b2Vec2): b2Vec2; overload;
begin
  Result.b2Vec2(-s * a.y, s * a.x);
end;  

function b2Mul(const A: b2Mat22; const v: b2Vec2): b2Vec2; overload;
begin
  Result.b2Vec2(A.ex.x * v.x + A.ey.x * v.y, A.ex.y * v.x + A.ey.y * v.y);
end;  

function b2Mult(const A: b2Mat22; const v: b2Vec2): b2Vec2; overload;
begin
  Result.b2Vec2(b2Dot(v, A.ex), b2Dot(v, A.ey));
end;  

function b2Vec2Add(const a, b: b2Vec2): b2Vec2;
begin
  Result.b2Vec2(a.x + b.x, a.y + b.y);
end;  

function b2Vec2Sub(const a, b: b2Vec2): b2Vec2;
begin
  Result.b2Vec2(a.x - b.x, a.y - b.y);
end;  

function b2Vec2Mul(s: float32; const a: b2Vec2): b2Vec2;
begin
  Result.b2Vec2(s * a.x, s * a.y);
end;  

function b2Vec2Equal(const a, b: b2Vec2): Boolean;
begin
  Result := (a.x = b.x) and (a.y = b.y);
end;  

function b2Distance(const a, b: b2Vec2): float32;
var
  c: b2Vec2;
begin
  c := b2Vec2Sub(a, b);
  Result := c.Length();
end;  

function b2DistanceSquared(const a, b: b2Vec2): float32;
var
  c: b2Vec2;
begin
  c := b2Vec2Sub(a, b);
  Result := b2Dot(c, c);
end;  

function b2Vec3Mul(s: float32; const a: b2Vec3): b2Vec3;
begin
  Result.b2Vec3(s * a.x, s * a.y, s * a.z);
end;  

function b2Vec3Add(const a, b: b2Vec3): b2Vec3;
begin
  Result.b2Vec3(a.x + b.x, a.y + b.y, a.z + b.z);
end;  

function b2Vec3Sub(const a, b: b2Vec3): b2Vec3;
begin
  Result.b2Vec3(a.x - b.x, a.y - b.y, a.z - b.z);
end;  

function b2Dot(const a, b: b2Vec3): float32; overload;
begin
  Result := a.x * b.x + a.y * b.y + a.z * b.z;
end;  

function b2Cross(const a, b: b2Vec3): b2Vec3; overload;
begin
  Result.b2Vec3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
end;  

function b2Mat22Add(const A, B: b2Mat22): b2Mat22;
begin
  Result.b2Mat22(b2Vec2Add(A.ex, B.ex), b2Vec2Add(A.ey, B.ey));
end;  

function b2Mul(const A, B: b2Mat22): b2Mat22; overload;
begin
  Result.b2Mat22(b2Mul(A, B.ex), b2Mul(A, B.ey));
end;  

function b2Mult(const A, B: b2Mat22): b2Mat22; overload;
var
  c1, c2: b2Vec2;
begin
  c1.b2Vec2(b2Dot(A.ex, B.ex), b2Dot(A.ey, B.ex));
  c2.b2Vec2(b2Dot(A.ex, B.ey), b2Dot(A.ey, B.ey));
  Result.b2Mat22(c1, c2);
end;  

function b2Mul(const A: b2Mat33; const v: b2Vec3): b2Vec3; overload;
var
  midvalue: b2Vec3;
begin
  midvalue := b2Vec3Add(b2Vec3Mul(v.x, A.ex), b2Vec3Mul(v.y, A.ey));
  Result := b2Vec3Add(midvalue, b2Vec3Mul(v.z, A.ez));
end;  

function b2Mul22(const A: b2Mat33; const v: b2Vec2): b2Vec2;
begin
  Result.b2Vec2(A.ex.x * v.x + A.ey.x * v.y, A.ex.y * v.x + A.ey.y * v.y);
end;  

function b2Mul(const q, r: b2Rot): b2Rot; overload;
var
  qr: b2Rot;
begin
  qr.s := q.s * r.c + q.c * r.s;
	qr.c := q.c * r.c - q.s * r.s;
  Result := qr;
end;  

function b2Mult(const q, r: b2Rot): b2Rot; overload;
var
  qr: b2Rot;
begin
  qr.s := q.c * r.s - q.s * r.c;
	qr.c := q.c * r.c + q.s * r.s;
  Result := qr;
end;  

function b2Mul(const q: b2Rot; const v: b2Vec2): b2Vec2; overload;
begin
  Result.b2Vec2(q.c * v.x - q.s * v.y, q.s * v.x + q.c * v.y);
end;  

function b2Mult(const q: b2Rot; const v: b2Vec2): b2Vec2; overload;
begin
  Result.b2Vec2(q.c * v.x + q.s * v.y, -q.s * v.x + q.c * v.y);
end;  

function b2Mul(const T: b2Transform; const v: b2Vec2): b2Vec2; overload;
var
  x, y: float32;
begin
  x := (T.q.c * v.x - T.q.s * v.y) + T.p.x;
	y := (T.q.s * v.x + T.q.c * v.y) + T.p.y;
  Result.b2Vec2(x, y);
end;  

function b2Mult(const T: b2Transform; const v: b2Vec2): b2Vec2; overload;
var
  px, py, x, y: float32;
begin
  px := v.x - T.p.x;
  py := v.y - T.p.y;
  x := (T.q.c * px + T.q.s * py);
  y := (-T.q.s * px + T.q.c * py);
  Result.b2Vec2(x, y);
end;  

function b2Mul(const A, B: b2Transform): b2Transform; overload;
var
  C: b2Transform;
begin
  C.q := b2Mul(A.q, B.q);
  C.p := b2Vec2Add(b2Mul(A.q, B.p), A.p);
  Result := C;
end;  

function b2Mult(const A, B: b2Transform): b2Transform; overload;
var
  C: b2Transform;
begin
  C.q := b2Mult(A.q, B.q);
  C.p := b2Mult(A.q, b2Vec2Sub(B.p, A.p));
  Result := C;
end;  

function b2NextPowerOfTwo(x: uint32): uint32;
begin
	x := x or (x shr 1);
	x := x or (x shr 2);
	x := x or (x shr 4);
	x := x or (x shr 8);
	x := x or (x shr 16);
  Result := x + 1;
end;  

function b2IsPowerOfTwo(x: uint32): Boolean;
begin
  Result := (x > 0) and ( (x and (x - 1)) = 0 );
end;

function b2Abs(const a: b2Vec2): b2Vec2; overload;
begin
  Result.b2Vec2(Abs(a.x), Abs(a.y));
end;  

function b2Abs(const A: b2Mat22): b2Mat22; overload;
begin
  Result.b2Mat22(b2Abs(A.ex), b2Abs(A.ey));
end;

function b2Min(const a, b: b2Vec2): b2Vec2;
begin
  Result.SetValue(Min(a.x, b.x), Min(a.y, b.y));
end;  

function b2Max(const a, b: b2Vec2): b2Vec2;
begin
  Result.SetValue(Max(a.x, b.x), Max(a.y, b.y));
end;

function b2Clamp(a, low, high: float32): float32;
begin
  Result := Max(low, Min(a, high));
end;

function b2Clamp(a, low, high: b2Vec2): b2Vec2; overload;
begin
  Result := b2Max(low, b2Min(a, high));
end;

function MakeVector(x, y: float32): b2Vec2;
begin
  Result.x := x;
  Result.y := y;
end;

function b2Mul(const T: Transform; const v: b2Vec2): b2Vec2;
begin
  Result := b2Vec2Add(b2Mul(T.R, v), T.P);
end;  

end.
