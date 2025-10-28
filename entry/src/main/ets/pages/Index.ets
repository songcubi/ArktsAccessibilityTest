import font from '@ohos.font';
import { display, uiAppearance, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { EnvironmentCallback } from '@kit.AbilityKit';

let callbackId: number;

@Entry
@Component
struct Index {
  @State fontWeightScale: string = 'none';
  @State fontScale: string = 'none';
  @State darkMode: string = 'none';
  @State scaledDensity: string = 'none';
  @State fontWeightScaleConfUpdate: string = 'ConfUpdate';
  @State fontScaleConfUpdate: string = 'ConfUpdate';
  @State darkModeConfUpdate: string = 'ConfUpdate';
  @State scaledDensityConfUpdate: string = 'ConfUpdate';

  aboutToAppear() {


    const uiContext = this.getUIContext();
    const hostContext = uiContext.getHostContext();
    const appContext = hostContext?.getApplicationContext();
    try {
      callbackId = appContext?.on('environment', this.environmentCallback()) || 0;
    } catch (paramError) {
    }

  }

  aboutToDisappear() {
    const uiContext = this.getUIContext();
    const hostContext = uiContext.getHostContext();
    const appContext = hostContext?.getApplicationContext();
    if (callbackId !== 0) {
      appContext?.off('environment', callbackId);
    }
  }

  environmentCallback(): EnvironmentCallback {
    const that = this;
    return {
      onConfigurationUpdated(config) {
        that.darkModeConfUpdate = JSON.stringify(config.colorMode);
        that.fontWeightScaleConfUpdate= JSON.stringify(config.fontWeightScale);
        that.fontScaleConfUpdate= JSON.stringify(config.fontSizeScale);
        that.scaledDensityConfUpdate=config.screenDensity? JSON.stringify(config.screenDensity/160): 'none';

        console.info(`onConfigurationUpdated config: ${JSON.stringify(config)}`);
      },
      onMemoryLevel(level) {
        console.info(`onMemoryLevel level: ${level}`);
      }
    };
  }

  build() {
    Column() {
      Button("getUIFontConfig")
        .width('60%')
        .height('6%')
        .margin(50)
        .onClick(() => {
          try {
            this.fontWeightScale = JSON.stringify(uiAppearance.getFontWeightScale());
            this.fontScale = JSON.stringify(uiAppearance.getFontScale());
            this.darkMode = JSON.stringify(uiAppearance.getDarkMode());
            let displayObj = display.getDefaultDisplaySync();
            this.scaledDensity = JSON.stringify(displayObj.scaledDensity);


          } catch (error) {
            console.log(error);
          }
        })

      Text(`fontWeightScale=${this.fontWeightScale}`)
      Text(`fontScale=${this.fontScale}`)
      Text(`darkMode=${this.darkMode}`)
      Text(`scaledDensity=${this.scaledDensity}`)

      Blank().height(20)

      Text(`fontWeightScaleConfUpdate=${this.fontWeightScaleConfUpdate}`)
      Text(`fontScaleConfUpdate=${this.fontScaleConfUpdate}`)
      Text(`darkModeConfUpdate=${this.darkModeConfUpdate}`)
      Text(`scaledDensityConfUpdate=${this.scaledDensityConfUpdate}`)
        .accessibilityText("需要获取系统设置以显示字体配置信息")


      Blank().height(20)
      Text("屏幕朗读")
      Button("")
        .width(30)
        .height(30)
        .margin(50)
        .backgroundColor(Color.Green)

      Button("读取身份")
        .width(80)
        .height(30)
        .margin(50)
        .backgroundColor(Color.Blue)

      Button("")
        .width(30)
        .height(30)
        .margin(50)
        .backgroundColor(Color.Red)
        .accessibilityText("自定义的无障碍文本")


    }.width('100%')
  }
}