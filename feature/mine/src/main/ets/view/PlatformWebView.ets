/**
 * 项目名称: ApiUsage
 * 文件名称: PlatformWebView
 * 创建时间: 2026-08-20 22:05
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */

import { webview } from '@kit.ArkWeb';
import { hdsMaterial, HdsNavDestination, ScrollEffectType } from '@kit.UIDesignKit';
import { CommonConstants, GlobalInfoModel, PageContext, StorageKey } from 'common';


@Builder
export function PlatformWebViewBuilder() {
  PlatformWebView();
}

@Component
export struct PlatformWebView {
  private readonly webController: webview.WebviewController =
    new webview.WebviewController();
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  // 控制顶部网页加载进度条是否显示。
  @State pageLoading: boolean = true;
  // 保存 ArkWeb 回调返回的当前页面加载进度，取值范围为 0 到 100。
  @State loadingProgress: number = 0;
  // 保存当前 Web 页面 URL，用于判断是否已经回到 Platform 主页。
  @State currentPageUrl: string = '';
  // 保存首次稳定进入 /usage 时的 Web 历史位置，作为当前 Web 页面的返回边界。
  private platformRootHistoryIndex: number = -1;

  /**
   * 统一处理 Web URL，只向业务逻辑返回可直接比较的地址。
   */
  private normalizePlatformUrl(url: string): string {
    let normalizedUrl: string = url.split('?')[0].split('#')[0];
    if (normalizedUrl.endsWith('/')) {
      normalizedUrl = normalizedUrl.substring(0, normalizedUrl.length - 1);
    }
    return normalizedUrl;
  }

  /**
   * 首次确认进入 /usage 时建立 Web 历史边界。
   * 该方法同时承担返回前的补救初始化，避免核心返回逻辑处理 URL 细节。
   */
  private ensurePlatformRootHistoryIndex(
    url: string,
    historyList: webview.BackForwardList
  ): void {
    const normalizedUrl: string = this.normalizePlatformUrl(url);
    const isUsagePage: boolean = normalizedUrl === 'https://platform.deepseek.com/usage';
    if (isUsagePage && this.platformRootHistoryIndex < 0) {
      this.platformRootHistoryIndex = historyList.currentIndex;
    }
  }

  /**
   * 处理系统返回键：优先返回 Web 历史，回到根位置后再交给 App 路由退出。
   */
  private handlePlatformBackPress(): boolean {
    // 直接读取 Web 当前 URL，避免单页应用内部切换路由时状态变量没有及时更新。
    let currentUrl: string = this.webController.getUrl();
    if (currentUrl.length === 0) {
      currentUrl = this.currentPageUrl;
    }

    const historyList: webview.BackForwardList = this.webController.getBackForwardEntries();

    // 正常情况下根位置已在 onPageEnd 建立；这里仅保留补救初始化入口。
    this.ensurePlatformRootHistoryIndex(currentUrl, historyList);

    // 只有当前位置仍在根页面之后，才允许 Web 后退；回到根位置后交给 App 路由退出。
    if (this.platformRootHistoryIndex >= 0
      && historyList.currentIndex > this.platformRootHistoryIndex
      && this.webController.accessBackward()) {
      // 返回 Web 历史栈中的上一页。
      this.webController.backward();

      // 返回 true，表示返回事件已经被当前页面消费，暂不退出 App 路由。
      return true;
    }

    // 根位置之前或没有可后退历史时，返回 false，让外层路由退出当前页面。
    if (this.platformRootHistoryIndex >= 0) {
      return false;
    }

    // 未能建立根位置时，保留 ArkWeb 的兜底历史判断。
    if (this.webController.accessBackward()) {
      this.webController.backward();
      return true;
    }

    // Web 没有上一页时，返回 false，让外层路由退出当前页面。
    return false;
  }

  build(): void {
    HdsNavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        Web({
          src: 'https://platform.deepseek.com/',
          controller: this.webController
        })
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .width(CommonConstants.FULL_PERCENT)
          .height(CommonConstants.FULL_PERCENT)
          // 主页面开始加载时，显示进度条并将进度重置为 0。
          .onPageBegin((event: OnPageBeginEvent) => {
            // 页面开始加载时先记录目标 URL，避免加载过程中仍沿用旧页面地址。
            this.currentPageUrl = event.url;
            this.pageLoading = true;
            this.loadingProgress = 0;
          })
          // 页面加载进度变化时，同步更新顶部进度条的当前值。
          .onProgressChange((event: OnProgressChangeEvent) => {
            this.loadingProgress = Math.max(0, Math.min(100, event.newProgress));
          })
          // 主页面加载完成后，将进度设置为 100，并隐藏顶部进度条。
          .onPageEnd((event: OnPageEndEvent) => {
            this.currentPageUrl = event.url;

            // 登录后的用量主页是 Web 历史边界，只在第一次到达时记录真实索引。
            const historyList: webview.BackForwardList = this.webController.getBackForwardEntries();
            this.ensurePlatformRootHistoryIndex(event.url, historyList);

            this.loadingProgress = 100;
            this.pageLoading = false;
          })

        // 仅在网页加载期间渲染进度条；加载完成后自动从页面中移除。
        if (this.pageLoading) {
          Progress({
            value: this.loadingProgress,
            total: 100,
            type: ProgressType.Linear,
          })
            .width(CommonConstants.FULL_PERCENT)
            .height(2)
            .color($r('app.color.primary_color'))
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .margin({
        top: this.globalInfoModel.statusBarHeight + CommonConstants.NAVIGATION_HEIGHT,
        bottom: this.globalInfoModel.naviIndicatorHeight,
      });
    }
    .titleBar({
      style: {
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        },
        scrollEffectOpts: {
          enableScrollEffect: true,
          scrollEffectType: ScrollEffectType.GRADIENT_BLUR,
        },
      },
      content: {
        title: { mainTitle: $r('app.string.api_Enhancement') },
        // 为标题栏返回按钮设置独立行为，直接退出当前 App 路由。
        backIcon: {
          action: () => {
            const pageContext = AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT);
            pageContext?.popPage();
          },
        },
      },
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    // 优先处理网页历史返回；网页没有上一页时，再交给外层 App 路由处理。
    .onBackPressed(() => {
      return this.handlePlatformBackPress();
    });
  }
}
