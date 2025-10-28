import font from '@ohos.font';
import { display, PromptAction, uiAppearance, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { EnvironmentCallback } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  private screenDensityCallBack: Callback<number> | null = null;
  private environmentCallback: EnvironmentCallback | null = null;
  @State fontWeightScale: string = 'none';
  @State fontScale: string = 'none';
  @State darkMode: string = 'none';
  @State scaledDensity: string = 'none';
  @State fontWeightScaleConfUpdate: string = 'ConfUpdate';
  @State fontScaleConfUpdate: string = 'ConfUpdate';
  @State darkModeConfUpdate: string = 'ConfUpdate';
  @State screenDensityConfUpdate: string = 'ConfUpdate';

  aboutToAppear() {
    this.registerAppContextEnvironmentChange();
    this.registerScreenDensityChange();
  }

  aboutToDisappear() {
  }

  /**
   * 监听显示大小缩放scaledDensity
   */
  registerScreenDensityChange() {
    this.screenDensityCallBack = (data: number) => {
      try {
        this.screenDensityConfUpdate = JSON.stringify(display.getDefaultDisplaySync().scaledDensity);
      } catch (error) {
        hilog.error(0x0000, 'ohos.arkui.ui.Index', 'registerScreenDensityChange error');
      }
    }
    display.on('change', this.screenDensityCallBack);
  }

  /**
   * 监听字体粗细修改fontWeightScale
   * 监听主题显示模式colorMode
   */
  registerAppContextEnvironmentChange() {
    let that=this;
    this.environmentCallback = {
      onConfigurationUpdated(config) {
        that.fontScaleConfUpdate = JSON.stringify(config.fontSizeScale);
        that.fontWeightScaleConfUpdate = JSON.stringify(config.fontWeightScale);
        that.darkModeConfUpdate = JSON.stringify(config.colorMode);
      },
      onMemoryLevel(level) {
        console.log('onMemoryLevel')
      }
    }
    const appContext = this.getUIContext().getHostContext()?.getApplicationContext();
    try {
      appContext?.on('environment', this.environmentCallback)
    } catch (paramError) {
      hilog.error(0x0000, 'ohos.arkui.ui.Index', 'registerAppContextEnvironmentChange error');
    }
  }

  build() {
    Column() {
      Button("getUIFontConfig")
        .width('60%')
        .height('6%')
        .margin(50)
        .onClick(() => {
          try {
            this.fontScale = JSON.stringify(uiAppearance.getFontScale());
            this.fontWeightScale = JSON.stringify(uiAppearance.getFontWeightScale());
            this.scaledDensity = JSON.stringify(display.getDefaultDisplaySync().scaledDensity);
            this.darkMode = JSON.stringify(uiAppearance.getDarkMode());

          } catch (error) {
            console.log(error);
          }
        })

      Text(`字体大小=${this.fontScale}`)
      Text(`字体粗细=${this.fontWeightScale}`)
      Text(`显示大小缩放=${this.scaledDensity}`)
      Text(`darkMode=${this.darkMode}`)

      Blank().height(20)

      Text(`字体大小=${this.fontScaleConfUpdate}`)
      Text(`字体粗细=${this.fontWeightScaleConfUpdate}`)
      Text(`显示大小缩放=${this.screenDensityConfUpdate}`)
      Text(`darkModeConfUpdate=${this.darkModeConfUpdate}`)


      // Blank().height(20)
      // Button("")
      //   .width(30)
      //   .height(30)
      //   .margin(50)
      //   .backgroundColor(Color.Green)
      //   .onClick(() => {
      //     try {
      //       this.promptAction.showToast({
      //         message: 'aboutToDisappear',
      //         duration: 2000
      //       })
      //     } catch (error) {
      //     }
      //   })
      //
      // Button("读取身份")
      //   .width(80)
      //   .height(30)
      //   .margin(50)
      //   .backgroundColor(Color.Blue)
      //
      // Button("")
      //   .width(30)
      //   .height(30)
      //   .margin(50)
      //   .backgroundColor(Color.Red)
      //   .accessibilityText("自定义的无障碍文本")

    }.width('100%')
  }
}