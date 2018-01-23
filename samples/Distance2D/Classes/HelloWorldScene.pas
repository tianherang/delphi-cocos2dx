unit HelloWorldScene;

interface
uses
  Cocos2dx.CCObject, Cocos2dx.CCLayer, Cocos2dx.CCScene, Cocos2dx.CCPlatformMacros,
  Cocos2dx.CCSprite, Cocos2dx.CCSet;

type
  HelloWorld = class(CCLayer)
  public
    constructor Create();
    destructor Destroy(); override;
    procedure onEnter(); override;
    function init(): Boolean; override;
    procedure draw(); override;
    class function scene(): CCScene;
    class function _create(): HelloWorld;
    procedure closeCallback(pObj: CCObject);
  end;

implementation
uses
  box2d.b2Settings, box2d.b2Math, Distance,
  Cocos2dx.CCGeometry, Cocos2dx.CCDirector, Cocos2dx.CCPointExtension,
  Cocos2dx.CCDrawingPrimitives,Cocos2dx.CCMacros, Cocos2dx.CCTypes,
  Cocos2dx.CCLabelTTF, Cocos2dx.CCMenuItem, Cocos2dx.CCMenu,
  Cocos2dx.CCActionInterval;

{ HelloWorld }

class function HelloWorld._create: HelloWorld;
var
  pRet: HelloWorld;
begin
  pRet := HelloWorld.Create();
  if (pRet <> nil) and pRet.init() then
    pRet.autorelease()
  else
    CC_SAFE_DELETE(pRet);

  Result := pRet;
end;

constructor HelloWorld.Create;
begin
  inherited Create();
end;

function HelloWorld.init: Boolean;
begin

  Result := True;
end;

class function HelloWorld.scene: CCScene;
var
  scene: CCScene;
  layer: HelloWorld;
begin
  scene := CCScene._Create();
  if scene = nil then
  begin
    Result := nil;
    Exit;
  end;
  layer := HelloWorld._create();
  if layer = nil then
  begin
    Result := nil;
    Exit;
  end;

  scene.addChild(layer);

  Result := scene;
end;


procedure HelloWorld.closeCallback(pObj: CCObject);
begin
  CCDirector.sharedDirector()._end();
end;

destructor HelloWorld.Destroy;
begin

  inherited;
end;

type
  DrawType = (e_drawPoints, e_drawPolygon);

const e_maxPoints = 20;
var
  points1, points2: array [0..e_maxPoints-1] of b2Vec2;
  polygon1, polygon2: Polygon;
  drawType1, drawType2: DrawType;
  demoIndex: Integer;
  angle: float32;
  position: b2Vec2;
  drawSimplex: Boolean;
  simplexIndex: Integer;

procedure Demo1();
begin
  points1[0].SetValue(0.0, 0.0);
  polygon1.m_points := @points1[0];
  polygon1.m_count := 1;
  drawType1 := e_drawPoints;

  points2[0].SetValue(0.0, -1.0);
  points2[1].SetValue(0.0, 1.0);
  polygon2.m_points := @points2[0];
  polygon2.m_count := 2;
  drawType2 := e_drawPolygon;
end;

procedure Demo2();
var
  angle: float32;
  i: Integer;
begin
  points1[0].SetValue(0.0, 0.0);
  polygon1.m_points := @points1[0];
  polygon1.m_count := 1;
  drawType1 := e_drawPoints;

  angle := 0.0;
  for i := 0 to 2 do
  begin
    points2[i].SetValue(Cos(angle), Sin(angle));
    angle := angle + 2.0 * Pi / 3.0;
  end;
  polygon2.m_points := @points2[0];
  polygon2.m_count := 3;
  drawType2 := e_drawPolygon;
end;

procedure Demo3();
var
  angle: float32;
  i: Integer;
begin
  points1[0].SetValue(0.0, 0.0);
  polygon1.m_points := @points1[0];
  polygon1.m_count := 1;
  drawType1 := e_drawPoints;

  angle := 0.0;
  for i := 0 to 5 do
  begin
    points2[i].SetValue(Cos(angle), Sin(angle));
    angle := angle + Pi / 3.0;
  end;
  polygon2.m_points := @points2[0];
  polygon2.m_count := 6;
  drawType2 := e_drawPolygon;
end;

procedure Demo4();
begin
  points1[0].SetValue(-1.0, -1.0);
  points1[1].SetValue(1.0, -1.0);
  points1[2].SetValue(1.0, 1.0);
  points1[3].SetValue(-1.0, 1.0);
  polygon1.m_points := @points1[0];
  polygon1.m_count := 4;
  drawType1 := e_drawPolygon;

  points2[0].SetValue(0.0, -1.0);
  points2[1].SetValue(0.0, 1.0);
  polygon2.m_points := @points2[0];
  polygon2.m_count := 2;
  drawType2 := e_drawPolygon;
end;

procedure Demo5();
var
  angle: float32;
  i: Integer;
begin
  points1[0].SetValue(-1.0, -1.0);
  points1[1].SetValue(1.0, -1.0);
  points1[2].SetValue(1.0, 1.0);
  points1[3].SetValue(-1.0, 1.0);
  polygon1.m_points := @points1[0];
  polygon1.m_count := 4;
  drawType1 := e_drawPolygon;

  angle := 0.0;
  for i := 0 to 2 do
  begin
    points2[i].SetValue(Cos(angle), Sin(angle));
    angle := angle + 2.0 * Pi / 3.0;
  end;

  polygon2.m_points := @points2[0];
  polygon2.m_count := 3;
  drawType2 := e_drawPolygon;
end;

procedure Demo6();
begin
  points1[0].SetValue(0.0, 0.0);
  polygon1.m_points := @points1[0];
  polygon1.m_count := 1;
  drawType1 := e_drawPoints;

  points2[0].SetValue(-1.0, -1.0);
  points2[1].SetValue(0.0, -1.0);
	points2[2].SetValue(1.0, -1.0);
	points2[3].SetValue(1.0, 0.0);
	points2[4].SetValue(1.0, 1.0);
	points2[5].SetValue(0.0, 1.0);
	points2[6].SetValue(-1.0, 1.0);
	points2[7].SetValue(-1.0, 0.0);
  polygon2.m_points := @points2[0];
  polygon2.m_count := 8;
  drawType2 := e_drawPolygon;
end;

type
  Demo = procedure ();

var
  demos: array [0..5] of Demo = (Demo1, Demo2, Demo3, Demo4, Demo5, Demo6);
  demoStrings: array [0..5] of string = (
    'Demo 1: Point vs Line Segment',
  	'Demo 2: Point vs Triangle',
  	'Demo 3: Point vs Hexagon',
  	'Demo 4: Square vs Line Segment',
  	'Demo 5: Square vs Triangle',
  	'Demo 6: Collinear Square vs Triangle'
  );

procedure InitDemo(index: Integer);
begin
  demoIndex := index;
  demos[index]();
  angle := 0.0;
  position.SetValue(2.0, 0.0);
end;

procedure DrawAsPoints(const poly: Polygon; const trans: Transform);
var
  p: b2Vec2;
  i: Integer;
  cc: CCPoint;
begin
  ccPointSize(10);
  ccDrawColor4F(0.9, 0.9, 0.9, 1.0);
  for i := 0 to poly.m_count-1 do
  begin
    p := b2Mul(trans, poly.m_points[i]);
    cc.x := p.x;
    cc.y := p.y;
    ccDrawPoint(cc);
  end;  
end;

procedure DrawAsPolygon(const poly: Polygon; const trans: Transform);
var
  ccs: array of CCPoint;
  i: Integer;
  p: b2Vec2;
begin
  ccDrawColor4F(0.9, 0.9, 0.9, 1.0);
  SetLength(ccs, poly.m_count);

  for i := 0 to poly.m_count-1 do
  begin
    p := b2Mul(trans, poly.m_points[i]);
    ccs[i].x := p.x;
    ccs[i].y := p.y;
  end;
  ccDrawPoly(@ccs[0], poly.m_count, True);
end;

procedure DrawPolygon(const poly: Polygon; const trans: Transform; type_: DrawType);
begin
  if type_ = e_drawPoints then
  begin
    DrawAsPoints(poly, trans);
  end else
  begin
    DrawAsPolygon(poly, trans);
  end;    
end;  

procedure SimulationLoop();
var
  in_put: Input;
  out_put: Output;
  s: Simplex;
  p1, p2: b2Vec2;
  cc, cc2: CCPoint;
  vertices: PSimplexVertexs;
  v: PSimplexVertex;
  i: Integer;
begin
  in_put.polygon1 := polygon1;
  in_put.polygon2 := polygon2;
  in_put.transform1.P.SetValue(0.0, 0.0);
  in_put.transform1.R.SetValue(0.0);
  in_put.transform2.P := position;
  in_put.transform2.R.SetValue(angle);

  DrawPolygon(polygon1, in_put.transform1, drawType1);
  DrawPolygon(polygon2, in_put.transform2, drawType2);

  Distance2D(@out_put, @in_put);

  if simplexIndex < 0 then
  begin
    simplexIndex := 0;
  end;

  if simplexIndex >= out_put.simplexCount then
  begin
    simplexIndex := out_put.simplexCount - 1;
  end;

  if drawSimplex then
  begin
    s := out_put.simplices[simplexIndex];

    s.GetWitnessPoints(@p1, @p2);

    ccPointSize(10);
    ccDrawColor4F(0.4, 0.8, 0.4, 1.0);
    cc.x := p1.x;
    cc.y := p1.y;
    ccDrawPoint(cc);
    ccDrawColor4F(0.8, 0.4, 0.4, 1.0);
    cc2.x := p2.x;
    cc2.y := p2.y;
    ccDrawPoint(cc2);

    ccDrawColor4F(0.4, 0.4, 0.8, 1.0);
    ccDrawLine(cc, cc2);

    vertices := @s.m_vertexA;

    for i := 0 to s.m_count-1 do
    begin
      v := @vertices[i];

      ccDrawColor4F(0.9, 0.5, 0.0, 1.0);
      ccPointSize(10.0);
      cc.x := v.point1.x; cc.y := v.point1.y;
      cc2.x := v.point2.x; cc2.y := v.point2.y;
      ccDrawLine(cc, cc2);
    end;  
  end else
  begin
    p1 := out_put.point1;
    p2 := out_put.point2;

    cc.x := p1.x; cc.y := p1.y;
    cc2.x := p2.x; cc2.y := p2.y;

    ccPointSize(10.0);
    ccDrawColor4F(0.4, 0.8, 0.4, 1.0);
    ccDrawPoint(cc);
    ccDrawColor4F(0.8, 0.4, 0.4, 1.0);
    ccDrawPoint(cc2);

    ccDrawColor4F(0.4, 0.4, 0.8, 1.0);
    ccDrawLine(cc, cc2);
  end;  
end;  


procedure HelloWorld.onEnter;
var
  visibleSize: CCSize;
  origin: CCPoint;
  A, B, P, e, Q, d: b2Vec2;
  u, v, shouldBeZero: float32;
begin
  inherited;
  visibleSize := CCDirector.sharedDirector().getVisibleSize();
  position.SetValue(2.0, 0.0);

  A.SetValue(0.021119118, 79.584320);
  B.SetValue(0.020964622, -31.515678);
  P.SetZero();

  e := b2Vec2Sub(B, A);
  u := b2Dot( b2Vec2Sub(B, P), e ) / b2Dot(e, e);
  v := b2Dot( b2Vec2Sub(P, A), e ) / b2Dot(e, e);

  Q := b2Vec2Add( b2Vec2Mul(u, A), b2Vec2Mul(v, B) );
  d := b2Vec2Sub(P, Q);

  shouldBeZero := b2Dot(d, e);

  InitDemo(0);
end;

procedure HelloWorld.draw;
begin
  SimulationLoop();
end;

end.
