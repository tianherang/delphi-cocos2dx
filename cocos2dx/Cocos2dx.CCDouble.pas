(****************************************************************************
 Copyright (c) 2010-2012 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************)

unit Cocos2dx.CCDouble;

interface
uses
  Cocos2dx.CCObject;

type
  CCDouble = class(CCObject)
  private
    m_fValue: Double;
  public
    constructor Create(v: Double);
    destructor Destroy(); override;
    function getValue(): Double;
    class function _create(v: Double): CCDouble;
  end;

implementation

{ CCDouble }

class function CCDouble._create(v: Double): CCDouble;
var
  pRet: CCDouble;
begin
  pRet := CCDouble.Create(v);
  pRet.autorelease();
  Result := pRet;
end;

constructor CCDouble.Create(v: Double);
begin
  inherited Create();
  m_fValue := v;
end;

destructor CCDouble.Destroy;
begin

  inherited;
end;

function CCDouble.getValue: Double;
begin
  Result := m_fValue;
end;

end.
