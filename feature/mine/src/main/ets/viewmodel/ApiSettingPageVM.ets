/**
 * 项目名称: ApiUsage
 * 文件名称: ApiSettingPageVM
 * 创建时间: 2026-08-16
 * 创建人：  @author Ffffei
 * 文件描述: API Key 配置页面的数据驱动：初始化读取、保存、删除
 */
import { UIContext } from '@kit.ArkUI';
import { BaseVM, PreferenceManager, StorageKey } from "common";
import { ApiSettingPageState } from "./ApiSettingPageState";

export class ApiSettingPageVM extends BaseVM<ApiSettingPageState> {
  private static instance: ApiSettingPageVM;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();

  private constructor() {
    super(new ApiSettingPageState());
  }

  public static getInstance(): ApiSettingPageVM {
    if (!ApiSettingPageVM.instance) {
      ApiSettingPageVM.instance = new ApiSettingPageVM();
    }
    return ApiSettingPageVM.instance;
  }

  public sendEvent<T>(event: ApiSettingEventParam<T>): void {
    if (event.type === ApiSettingEventType.INIT_DATA) {
      this.initData();
    } else if (event.type === ApiSettingEventType.SAVE) {
      this.saveApiKey(event.param as string);
    } else if (event.type === ApiSettingEventType.DELETE) {
      this.deleteApiKey();
    }
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

  private saveApiKey(apiKeyInput: string): void {
    const key = apiKeyInput.trim();
    if (key.length === 0) {
      return;
    }
    this.preferenceManager.setValue<string>(StorageKey.DS_API_KEY, key);
    this.state.hasApiKey = true;
    this.state.savedKeyMasked = this.maskKey(key);
  }

  private deleteApiKey(): void {
    this.preferenceManager.deleteValue(StorageKey.DS_API_KEY);
    this.state.hasApiKey = false;
    this.state.savedKeyMasked = '';
  }
}

export enum ApiSettingEventType {
  INIT_DATA = 'initData',
  SAVE = 'saveApiKey',
  DELETE = 'deleteApiKey',
}

export interface ApiSettingEventParam<T> {
  type: ApiSettingEventType;
  param: T;
}
