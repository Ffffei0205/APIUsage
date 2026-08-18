/**
 * 项目名称: ApiUsage
 * 文件名称: ApiSettingPageVM
 * 文件描述: API 配置页面的数据驱动：多配置的初始化、启用、编辑、保存和删除
 */
import { UIContext } from '@kit.ArkUI';
import { ApiConfiguration, ApiConfigurationManager, BaseVM, PreferenceManager, StorageKey } from "common";
import { ApiSettingPageState } from "./ApiSettingPageState";

export class ApiSettingPageVM extends BaseVM<ApiSettingPageState> {
  private static instance: ApiSettingPageVM;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();
  private configurationManager: ApiConfigurationManager = ApiConfigurationManager.getInstance();

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
    } else if (event.type === ApiSettingEventType.ADD) {
      this.startAdding();
    } else if (event.type === ApiSettingEventType.ENABLE) {
      this.enableConfiguration(event.param as string);
    } else if (event.type === ApiSettingEventType.EDIT) {
      this.startEditing(event.param as string);
    } else if (event.type === ApiSettingEventType.CANCEL_EDIT) {
      this.cancelEditing();
    } else if (event.type === ApiSettingEventType.UPDATE_INPUT) {
      this.updateInput(event.param as string);
    } else if (event.type === ApiSettingEventType.SAVE) {
      this.saveConfiguration();
    } else if (event.type === ApiSettingEventType.DELETE) {
      this.deleteConfiguration(event.param as string);
    }
  }

  private initData(): void {
    const uiContext: UIContext | undefined = AppStorage.get<UIContext>(StorageKey.UI_CONTEXT);
    if (uiContext !== undefined) {
      this.preferenceManager.initPreference();
      this.loadConfigurations();
    } else {
      setTimeout(() => {
        this.initData();
      }, 100);
    }
  }

  private loadConfigurations(): void {
    this.state.apiConfigurations = this.configurationManager.getConfigurations();
  }

  private startAdding(): void {
    if (this.state.apiConfigurations.length >= ApiConfigurationManager.MAX_CONFIGURATION_COUNT) {
      return;
    }
    this.state.editingConfigurationId = '';
    this.state.apiKeyInput = '';
    this.state.isEditing = true;
  }

  private enableConfiguration(configurationId: string): void {
    const configurations: ApiConfiguration[] = this.configurationManager.getConfigurations();
    let hasTargetConfiguration: boolean = false;
    for (let index: number = 0; index < configurations.length; index++) {
      const configuration: ApiConfiguration | undefined = configurations[index];
      if (configuration !== undefined && configuration.id === configurationId) {
        hasTargetConfiguration = true;
        break;
      }
    }
    if (!hasTargetConfiguration) {
      return;
    }
    for (let index: number = 0; index < configurations.length; index++) {
      const configuration: ApiConfiguration | undefined = configurations[index];
      if (configuration !== undefined) {
        configuration.isEnabled = configuration.id === configurationId;
      }
    }
    this.configurationManager.saveConfigurations(configurations);
    this.loadConfigurations();
  }

  private startEditing(configurationId: string): void {
    const configurations: ApiConfiguration[] = this.configurationManager.getConfigurations();
    for (let index: number = 0; index < configurations.length; index++) {
      const configuration: ApiConfiguration | undefined = configurations[index];
      if (configuration !== undefined && configuration.id === configurationId) {
        this.state.editingConfigurationId = configurationId;
        this.state.apiKeyInput = '';
        this.state.isEditing = true;
        return;
      }
    }
  }

  private cancelEditing(): void {
    this.state.isEditing = false;
    this.state.editingConfigurationId = '';
    this.state.apiKeyInput = '';
  }

  private updateInput(apiKeyInput: string): void {
    this.state.apiKeyInput = apiKeyInput;
  }

  private saveConfiguration(): void {
    const apiKey: string = this.state.apiKeyInput.trim();
    if (apiKey.length === 0) {
      return;
    }

    const configurations: ApiConfiguration[] = this.configurationManager.getConfigurations();
    if (this.state.editingConfigurationId === '') {
      if (configurations.length >= ApiConfigurationManager.MAX_CONFIGURATION_COUNT) {
        return;
      }
      const configuration: ApiConfiguration = this.configurationManager.createConfiguration(
        apiKey, configurations.length === 0);
      configurations.push(configuration);
    } else {
      for (let index: number = 0; index < configurations.length; index++) {
        const configuration: ApiConfiguration | undefined = configurations[index];
        if (configuration !== undefined && configuration.id === this.state.editingConfigurationId) {
          configuration.apiKey = apiKey;
          configuration.updatedAt = Date.now();
          break;
        }
      }
    }
    this.configurationManager.saveConfigurations(configurations);
    this.loadConfigurations();
    this.cancelEditing();
  }

  private deleteConfiguration(configurationId: string): void {
    const configurations: ApiConfiguration[] = this.configurationManager.getConfigurations();
    const remainingConfigurations: ApiConfiguration[] = [];
    let deletedEnabledConfiguration: boolean = false;
    for (let index: number = 0; index < configurations.length; index++) {
      const configuration: ApiConfiguration | undefined = configurations[index];
      if (configuration !== undefined) {
        if (configuration.id === configurationId) {
          deletedEnabledConfiguration = configuration.isEnabled;
        } else {
          remainingConfigurations.push(configuration);
        }
      }
    }
    if (deletedEnabledConfiguration && remainingConfigurations.length > 0) {
      const nextEnabledConfiguration: ApiConfiguration | undefined = remainingConfigurations[0];
      if (nextEnabledConfiguration !== undefined) {
        nextEnabledConfiguration.isEnabled = true;
      }
    }
    this.configurationManager.saveConfigurations(remainingConfigurations);
    this.loadConfigurations();
  }
}

export enum ApiSettingEventType {
  INIT_DATA = 'initData',
  ADD = 'addApiConfiguration',
  ENABLE = 'enableApiConfiguration',
  EDIT = 'editApiConfiguration',
  CANCEL_EDIT = 'cancelEditApiConfiguration',
  UPDATE_INPUT = 'updateApiKeyInput',
  SAVE = 'saveApiConfiguration',
  DELETE = 'deleteApiConfiguration',
}

export interface ApiSettingEventParam<T> {
  type: ApiSettingEventType;
  param: T;
}
