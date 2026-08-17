/**
 * 项目名称: ApiUsage
 * 文件名称: BaseHomeViewModel
 * 创建时间: 2026-08-11 22:06
 * 创建人：  @author Ffffei
 * 文件描述: 所有 tab 首页 VM 的公共基类。
 */
import { BaseVM, ProcessUtil, StorageKey, Toast } from "common";
import { BaseHomeState } from "./BaseHomeState";
import { HdsTabsController, ScrollEffectOptions, ScrollEffectType, TitleBarStyleOptions } from "@kit.UIDesignKit";
import { common } from "@kit.AbilityKit";


const TAG = '[BaseHomeViewModel]';
const PRESS_TIME: number = 1500;

@Observed
export class BaseHomeViewModel<T extends BaseHomeState> extends BaseVM<BaseHomeState> {
  protected state: T;
  protected homeTabController: HdsTabsController = new HdsTabsController();
  private backPressTime: number = 0;

  public constructor(initialState: T) {
    super(initialState);
    this.state = initialState;
    this.setTitleBarStyle(); // 构造时先算一次初始标题栏样式
  }

  public getState(): T {
    return this.state;
  }

  public sendEvent<P>(eventParam: BaseHomeEventParam<P>): boolean | void {
    const eventType = eventParam.type;
    if (eventType === BaseHomeEventType.INITIALIZE) {
      this.initialize(eventParam.param as InitializeParam);
    }  else if (eventType === BaseHomeEventType.HANDLE_SCROLL_OFFSET) {
      return this.handleScrollOffset(eventParam.param as OffsetParam);
    } else if (eventType === BaseHomeEventType.ON_BACK_PRESS) {
      return this.onBackPress();
    }
    return false;
  }

  protected initialize(param: InitializeParam): void {
    this.homeTabController = param.homeTabController;
    this.state.scroller = param.scroller ?? new Scroller();
  }

  protected onBackPress(): boolean {
    const newTime = new Date().getTime();
    if (this.backPressTime && newTime - this.backPressTime < PRESS_TIME) {
      const uiContext = AppStorage.get<UIContext>(StorageKey.UI_CONTEXT);
      ProcessUtil.moveAbilityToBackground(uiContext?.getHostContext() as common.UIAbilityContext);
      return true;
    }
    this.backPressTime = newTime;
    Toast.showToast($r('app.string.back_toast'));
    return true;
  }

  /**
   * 处理滚动偏移：决定标题栏要不要变模糊。
   *
   * 业务侧接法（View 里）：
   *   Scroll(this.state.scroller)
   *     .onDidScroll((xOffset: number, yOffset: number) => {
   *       this.viewModel.sendEvent<OffsetParam>({
   *         type: BaseHomeEventType.HANDLE_SCROLL_OFFSET,
   *         param: { yOffset: yOffset },
   *       });
   *     })
   *
   * 逻辑：yOffset > 0 表示内容向上滑了 → isBlur = true（标题栏变模糊）；
   *       回到顶部（yOffset <= 0）→ isBlur = false（恢复）。
   * 改完开关后重新计算标题栏样式。
   */
  protected handleScrollOffset(param: OffsetParam): boolean {
    this.state.topNavigationData.isBlur = param.yOffset > 0;
    this.setTitleBarStyle();
    return true;
  }

  /**
   * 根据 topNavigationData.isBlur 生成 HDS 标题栏样式，存回 state。
   *
   * 业务侧接法（View 里）：
   *   HdsNavDestination() { ... }
   *     .bindToScrollable(this.state.scroller)      // 关键：告诉 HDS 跟哪个滚动容器联动
   *     .titleBar({
   *       style: this.state.topNavigationData.hdsTitleBarStyle,  // 这里用 VM 算好的样式
   *       content: { title: { mainTitle: ... } },
   *     })
   *
   * 注意：滚动模糊必须配合 bindToScrollable 才生效，
   * 光给 style 里的 scrollEffectOpts 是不够的（HDS 官方文档要求）。
   */
  protected setTitleBarStyle(): void {
    // 滚动模糊配置：isBlur 为 true 时开启滚动效果，类型用普通模糊
    const scrollEffectOpts: ScrollEffectOptions = {
      enableScrollEffect: this.state.topNavigationData.isBlur ?? false, // isBlur 为 true 时开启滚动效果
      scrollEffectType: ScrollEffectType.COMMON_BLUR, // 类型用普通模糊
    };
    const hdsTitleBarStyle: TitleBarStyleOptions = {
      scrollEffectOpts: scrollEffectOpts,
    };
    this.state.topNavigationData.hdsTitleBarStyle = hdsTitleBarStyle;
  }
}


export interface OffsetParam {
  yOffset: number;
}

export interface InitializeParam {
  homeTabController: HdsTabsController;
  scroller?: Scroller;
}

export interface BaseHomeEventParam<T> {
  type: BaseHomeEventType;
  param: T;
}


export enum BaseHomeEventType {
  HANDLE_SCROLL_OFFSET = 'handleScrollOffset',
  INITIALIZE = 'initialize',
  ON_BACK_PRESS = 'onBackPress',
  INIT_DATA = "INIT_DATA"
}