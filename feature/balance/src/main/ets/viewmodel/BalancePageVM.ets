/**
 * 项目名称: ApiUsage
 * 文件名称: BalancePageVM
 * 创建时间: 2026-08-14
 * 创建人：  @author Ffffei
 * 文件描述: 余额页面的数据驱动，负责读取 API Key、查询余额、刷新/重试
 */
import { UIContext } from '@kit.ArkUI';
import { ApiConfiguration, ApiConfigurationManager, LoadingStatus, PageContext, PageEnum, PreferenceManager, StorageKey } from "common";
import { BaseHomeEventParam, BaseHomeEventType, BaseHomeViewModel } from 'commonbusiness';
import DeepSeekApi, { BalanceResponse } from "../api/DeepSeekApi";
import { BalancePageState } from "./BalancePageState";

export class BalancePageVM extends BaseHomeViewModel<BalancePageState> {
  private static instance: BalancePageVM;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();
  private configurationManager: ApiConfigurationManager = ApiConfigurationManager.getInstance();

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
      this.preferenceManager.initPreference();
      this.loadApiKey();
    } else {
      setTimeout(() => {
        this.initData();
      }, 100);
    }
  }

  private loadApiKey(): void {
    const configuration: ApiConfiguration | undefined = this.configurationManager.getEnabledConfiguration();
    if (configuration !== undefined && configuration.apiKey.length > 0) {
      this.state.hasApiKey = true;
      this.state.savedKeyMasked = this.maskKey(configuration.apiKey);
      this.queryBalance(configuration.apiKey);
    } else {
      this.state.hasApiKey = false;
      this.state.savedKeyMasked = '';
    }
  }

  private maskKey(key: string): string {
    const prefixLength: number = Math.min(2, key.length);
    const hasSeparator: boolean = key.length > prefixLength && key.charAt(prefixLength) === '-';
    const keyBodyStartIndex: number = hasSeparator ? prefixLength + 1 : prefixLength;
    const startEndIndex: number = Math.min(keyBodyStartIndex + 5, key.length);
    const endStartIndex: number = Math.max(startEndIndex, key.length - 4);
    const prefix: string = key.substring(0, prefixLength);
    const start: string = key.substring(keyBodyStartIndex, startEndIndex);
    const end: string = key.substring(endStartIndex);
    return `${prefix}${hasSeparator ? '-' : ''}${start}*****${end}`;
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
    const configuration: ApiConfiguration | undefined = this.configurationManager.getEnabledConfiguration();
    if (configuration !== undefined && configuration.apiKey.length > 0) {
      this.queryBalance(configuration.apiKey);
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
