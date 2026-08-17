/**
 * 项目名称: ApiUsage
 * 文件名称: SplashView
 * 创建时间: 2026-08-14 21:39
 * 创建人：  @author Ffffei
 * 文件描述: 启动页组件
 */
import { SplashEventType, SplashViewModel } from "../viewmodel/SplashViewModel";

@Component
export struct SplashView {
  private viewModel: SplashViewModel = SplashViewModel.getInstance();

  aboutToAppear(): void {
    // 停留 1.5 秒后跳主界面（官方是动画结束后跳，这里用定时器简化）
    setTimeout(() => {
      this.viewModel.sendEvent<null>({
        type: SplashEventType.JUMP_TO_MAIN,
        param: null,
      });
    }, 0);
  }


  build() {
    Column() {
      Text('ApiUsage')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('sys.color.background_primary'))
  }
}