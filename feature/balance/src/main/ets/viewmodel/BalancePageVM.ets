/**
 * 项目名称: ApiUsage
 * 文件名称: BalancePageVM
 * 创建时间: 2026-08-14
 * 创建人：  @author Ffffei
 * 文件描述: 余额页面的数据驱动，负责读取 API Key、查询余额、刷新/重试
 */
import { UIContext } from '@kit.ArkUI';
import { LoadingStatus, PageContext, PageEnum, PreferenceManager, StorageKey } from "common";
import { BaseHomeEventParam, BaseHomeEventType, BaseHomeViewModel } from 'commonbusiness';
import DeepSeekApi, { BalanceResponse } from "../api/DeepSeekApi";
import { BalancePageState } from "./BalancePageState";

export class BalancePageVM extends BaseHomeViewModel<BalancePageState> {
  private static instance: BalancePageVM;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();

  private constructor() {
    super(new BalancePageState());
  }

  public static getInstance(): BalancePageVM {
    if (!BalancePageVM.instance) {
      BalancePageVM.instance = new BalancePageVM();
    }
    return BalancePageVM.instance;
  }

  public sendEvent<T>(event: BalanceEventParam<T>): void | boolean {
    const eventType: BalanceEventType | BaseHomeEventType = event.type;
    if (eventType === BalanceEventType.INIT_DATA) {
      this.initData();
    } else if (eventType === BalanceEventType.REFRESH) {
      this.refresh();
    }else if(eventType === BalanceEventType.JUMP_TO_API_SETTING_PAGE){
      this.jumpToAPISettingPage()
    }
    else {
      return super.sendEvent(event as BaseHomeEventParam<T>)
    }
  }

  jumpToAPISettingPage() {
    const pageContext = AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT);
    pageContext?.openPage({
      routerName: PageEnum.API_SETTING_VIEW,
    }, true);
  }

  private initData(): void {
    const uiContext: UIContext | undefined = AppStorage.get<UIContext>(StorageKey.UI_CONTEXT);
    if (uiContext != undefined) {
      this.preferenceManager.initPreference('hanbaoStore');
      this.loadApiKey();
    } else {
      setTimeout(() => {
        this.initData();
      }, 100);
    }
  }

  private loadApiKey(): void {
    const key: string | null = this.preferenceManager.getValue<string>(StorageKey.DS_API_KEY);
    if (key != null && key.length > 0) {
      this.state.hasApiKey = true;
      this.state.savedKeyMasked = this.maskKey(key);
      this.queryBalance(key);
    } else {
      this.state.hasApiKey = false;
      this.state.savedKeyMasked = '';
    }
  }

  private maskKey(key: string): string {
    if (key.length <= 8) {
      return '****';
    }
    const start = key.substring(0, 4);
    const end = key.substring(key.length - 4);
    return start + '****' + end;
  }

  private async queryBalance(apiKey: string): Promise<void> {
    this.state.loadingModel.loadingStatus = LoadingStatus.LOADING;
    try {
      const response: BalanceResponse = await DeepSeekApi.getBalance(apiKey);
      this.state.balanceResponse = response;
      this.state.loadingModel.loadingStatus = LoadingStatus.SUCCESS;
    } catch (error) {
      this.state.balanceResponse = undefined;
      this.state.loadingModel.loadingStatus = LoadingStatus.FAILED;
    }
  }

  private refresh(): void {
    const key: string | null = this.preferenceManager.getValue<string>(StorageKey.DS_API_KEY);
    if (key != null && key.length > 0) {
      this.queryBalance(key);
    }
  }
}


export enum BalanceEventType {
  INIT_DATA = 'initData',
  REFRESH = 'refresh',
  JUMP_TO_API_SETTING_PAGE = "jumpToAPISettingPage"
}

export interface BalanceEventParam<T> {
  type: BalanceEventType | BaseHomeEventType;
  param: T;
}
