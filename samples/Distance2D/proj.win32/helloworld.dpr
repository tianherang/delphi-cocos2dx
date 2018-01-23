program helloworld;


uses
  AppMacros in '..\Classes\AppMacros.pas',
  cAppDelegate in '..\Classes\cAppDelegate.pas',
  HelloWorldScene in '..\Classes\HelloWorldScene.pas',
  Cocos2dx.CCEGLView,
  Cocos2dx.CCApplication,
  box2d.b2Math in '..\Classes\box2d.b2Math.pas',
  box2d.b2Settings in '..\Classes\box2d.b2Settings.pas',
  Distance in '..\Classes\Distance.pas';

var
  app: AppDelegate;
  eglView: CCEGLView;
begin
  app := AppDelegate.Create();
  eglView := CCEGLView.sharedOpenGLView();
  eglView.setViewName('HelloCpp');
  eglView.setFrameSize(800, 600);
  eglView.setFrameZoomFactor(1);
  CCApplication.sharedApplication().run();
  app.Free;
end.
