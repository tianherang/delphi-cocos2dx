unit box2d.b2Settings;

interface
uses
  Math;

type
  int8    = type Shortint;
  int16   = type Smallint;
  int32   = type Integer;
  uint8   = type Byte;
  uint16  = type Word;
  uint32  = type Cardinal;
  float32 = type Single;
  float64 = type Double;

  pint8    = ^int8;
  pint16   = ^int16;
  pint32   = ^int32;
  puint8   = ^uint8;
  puint16  = ^uint16;
  puint32  = ^uint32;
  pfloat32 = ^float32;
  pfloat64 = ^float64;

  pint32s = ^int32s;
  int32s = array [0..MaxInt div SizeOf(int32) - 1] of int32;

  pfloat32s = ^float32s;
  float32s = array [0..MaxInt div SizeOf(float32) - 1] of float32;

const b2_maxFloat = MaxSingle;
const b2_epsilon = 1.192092896e-07;
const b2_pi = 3.14159265359;

const b2_maxManifoldPoints = 2;

const b2_maxPolygonVertices = 8;

const b2_aabbExtension = 0.1;

const b2_aabbMultiplier = 2.0;

const b2_linearSlop = 0.005;

const b2_angularSlop = 2.0 / 180.0 * b2_pi;

const b2_polygonRadius = 2.0 * b2_linearSlop;

const b2_maxSubSteps = 8;

const b2_maxTOIContacts = 32;

const b2_velocityThreshold = 1.0;

const b2_maxLinearCorrection = 0.2;

const b2_maxAngularCorrection = 8.0 / 180.0 * b2_pi;

const b2_maxTranslation = 2.0;
const b2_maxTranslationSquared = b2_maxTranslation * b2_maxTranslation;

const b2_maxRotation = 0.5 * b2_pi;
const b2_maxRotationSquared = b2_maxRotation * b2_maxRotation;

const b2_baumgarte = 0.2;
const b2_toiBaugarte = 0.75;

const b2_timeToSleep = 0.5;

const b2_linearSleepTolerance = 0.01;

const b2_angularSleepTolerance = 2.0 / 180.0 * b2_pi;

const UCHAR_MAX = 40;

function b2Alloc(size: int32): Pointer;
procedure b2Free(mem: Pointer);
procedure b2Log(const fmt: PAnsiChar; const Args: array of const); overload;
procedure b2Log(const msg: PAnsiChar); overload;

type
  b2Version = record
    major: int32;
    minor: int32;
    revision: int32;
  end;

const b2_version: b2Version = (
    major: 2;
    minor: 3;
    revision: 1);

procedure b2Assert(cond: Boolean); overload;
procedure b2Assert(cond: Boolean; msg: PAnsiChar); overload;
function _ptr(const p: Pointer; size: int32; offset: int32): Pointer;
function _ptrLessthen(const left, right: Pointer; size: int32 = 4; leftoffset: int32 = 0; rightoffset: int32 = 0): Boolean;
function RandomFloat(lo, hi: float32): float32;

implementation
uses
  SysUtils;

function b2Alloc(size: int32): Pointer;
begin
  Result := AllocMem(size);
end;

procedure b2Free(mem: Pointer);
begin
  FreeMemory(mem);
end;  

procedure b2Log(const fmt: PAnsiChar; const Args: array of const);
var
  str: string;
begin
  str := Format(fmt, Args);
  //Writeln(str);
end;

procedure b2Log(const msg: PAnsiChar);
var
  str: string;
begin
  str := Format(msg, []);
  //Writeln(str);
end;  

procedure b2Assert(cond: Boolean); overload;
begin
  Assert(cond, '');
end;

procedure b2Assert(cond: Boolean; msg: PAnsiChar); overload;
begin
  Assert(cond, msg);
end;

function _ptr(const p: Pointer; size: int32; offset: int32): Pointer;
begin
  Result := Pointer(int32(p) + size * offset);
end;

function _ptrLessthen(const left, right: Pointer; size, leftoffset, rightoffset: int32): Boolean;
var
  pleft, pright: Pointer;
begin
  pleft := _ptr(left, size, leftoffset);
  pright := _ptr(right, size, rightoffset);
  Result := int32(pleft) - int32(pright) < 0;
end;

function RandomFloat(lo, hi: float32): float32;
begin
  Result := (hi - lo) * Random + lo;
end;

end.
