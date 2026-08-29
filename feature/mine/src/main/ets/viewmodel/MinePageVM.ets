/**
 * 项目名称: ApiUsage
 * 文件名称: MinePageVM
 * 创建时间: 2026-08-13 00:29
 * 创建人：  @author Ffffei
 * 文件描述: “我的”页面的数据驱动，负责我的页面，子页面不包含
 */

import { BaseHomeEventParam, BaseHomeEventType, BaseHomeViewModel } from "commonbusiness";
import { PageContext, PageEnum, StorageKey } from "common";
import { AboutViewBuilder } from "../view/AboutView";
import { BuilderEnum, ListGroup, MineItem, MinePageState } from "./MinePageState";

export class MinePageVM extends BaseHomeViewModel<MinePageState> {
  private static instance: MinePageVM;
  private listGroupData: ListGroup[] = [];

  private constructor() {
    super(new MinePageState());
    this.initializeListGroupData();
  }

  public static getInstance() {
    if (!MinePageVM.instance) {
      MinePageVM.instance = new MinePageVM();
    }
    return MinePageVM.instance;
  }

  sendEvent<T>(event: MineEventParam<T>): void | boolean {
    const eventType: MineEventType | BaseHomeEventType = event.type;
    if (eventType === MineEventType.INIT_DATA) {
      this.assignData();
    } else if (eventType === MineEventType.JUMP_TO_SETTING_PAGE) {
      this.jumpToSettingPage()
    } else if (eventType === MineEventType.JUMP_TO_API_SETTING_PAGE) {
      this.jumpToAPISettingPage()
    } else if (eventType === MineEventType.JUMP_TO_PLATFORM_PAGE) {
      this.jumpToPlatformPage()
    } else if (eventType === MineEventType.SHOW_BIND_SHEET) {
      this.showBindSheet(event.param as MineItem);
    } else if (eventType === MineEventType.DISMISS_BIND_SHEET) {
      this.dismissBindSheet();
    } else {
      return super.sendEvent(event as BaseHomeEventParam<T>);
    }
  }


  private initializeListGroupData(): void {
    this.listGroupData = [
      {
        id: 0,
        group: [
          {
            textContent: $r('app.string.api_Enhancement'),
            symbolSrc: $r('sys.symbol.gearshape'),
            type: BuilderEnum.API_SETTING_ITEM,
            onclick: () => {
              MinePageVM.getInstance().sendEvent<null>({
                type: MineEventType.JUMP_TO_PLATFORM_PAGE,
                param: null
              })
            }
          }
        ]
      },
      {
        id: 1,
        group: [
          {
            textContent: $r('app.string.api_setting'),
            symbolSrc: $r('sys.symbol.gearshape'),
            type: BuilderEnum.API_SETTING_ITEM,
            onclick: () => {
              MinePageVM.getInstance().sendEvent<null>({
                type: MineEventType.JUMP_TO_API_SETTING_PAGE,
                param: null,
              });
            },
          },
        ],
      },
      {
        id: 2,
        group: [
          {
            textContent: $r('app.string.setting'),
            symbolSrc: $r('sys.symbol.gearshape'),
            type: BuilderEnum.CARD_ITEM,
            onclick: () => {
              MinePageVM.getInstance().sendEvent<null>({
                type: MineEventType.JUMP_TO_SETTING_PAGE,
                param: null,
              });
            },
          },
          {
            textContent: $r('app.string.about_app'),
            symbolSrc: $r('sys.symbol.info_circle'),
            type: BuilderEnum.CARD_ITEM,
            builder: wrapBuilder(AboutViewBuilder),
          },
        ],
      },
    ];
  }


  private assignData(): void {
    this.state.listItemData = this.listGroupData;
  }

  private showBindSheet(item: MineItem): void {
    this.state.bindSheetItem = item;
    this.state.bindSheetShow = true;
  }

  private dismissBindSheet(): void {
    this.state.bindSheetShow = false;
    this.state.bindSheetItem = undefined;
  }

  /**
   * 跳转至DeepSeek 开放平台
   */
  jumpToPlatformPage(): void {
    const pageContext = AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT);
    pageContext?.openPage({
      routerName: PageEnum.PLATFORM_WEB_VIEW,
    }, true);
  }

  /**
   * 跳转至API配置页面
   */
  jumpToAPISettingPage() {
    const pageContext = AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT);
    pageContext?.openPage({
      routerName: PageEnum.API_SETTING_VIEW,
    }, true)
  }

  /**
   * 跳转至设置页
   */
  private jumpToSettingPage() {
    const pageContext = AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT);
    pageContext?.openPage({
      routerName: PageEnum.SETTING_VIEW, // 你这里换成 PageEnum.SETTING_VIEW
    }, true);
  }
}


export enum MineEventType {
  INIT_DATA = 'initData',
  JUMP_TO_SETTING_PAGE = "jumpToSettingPage",
  JUMP_TO_API_SETTING_PAGE = "jumpToAPISettingPage",
  SHOW_BIND_SHEET = 'showBindSheet',
  DISMISS_BIND_SHEET = 'dismissBindSheet',
  JUMP_TO_PLATFORM_PAGE = "jumpToPlatformPage"
}

export interface MineEventParam<T> {
  type: MineEventType | BaseHomeEventType;
  param: T;
}
