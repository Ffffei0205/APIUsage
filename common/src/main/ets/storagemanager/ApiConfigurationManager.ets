import { StorageKey } from '../constant/CommonEnums';
import { ApiConfiguration } from '../model/ApiConfiguration';
import { PreferenceManager } from './PreferenceManager';

/**
 * API 配置的持久化入口。配置的业务规则由调用方 VM 保证。
 */
export class ApiConfigurationManager {
  public static readonly MAX_CONFIGURATION_COUNT: number = 5;
  private static instance: ApiConfigurationManager;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();

  private constructor() {
  }

  public static getInstance(): ApiConfigurationManager {
    if (!ApiConfigurationManager.instance) {
      ApiConfigurationManager.instance = new ApiConfigurationManager();
    }
    return ApiConfigurationManager.instance;
  }

  public getConfigurations(): ApiConfiguration[] {
    const storedConfigurations: ApiConfiguration[] | null =
      this.preferenceManager.getValue<ApiConfiguration[]>(StorageKey.API_CONFIGURATION_LIST);
    return storedConfigurations ?? [];
  }

  public saveConfigurations(configurations: ApiConfiguration[]): void {
    this.preferenceManager.setValue<ApiConfiguration[]>(StorageKey.API_CONFIGURATION_LIST, configurations);
  }

  public getEnabledConfiguration(): ApiConfiguration | undefined {
    const configurations: ApiConfiguration[] = this.getConfigurations();
    for (let index: number = 0; index < configurations.length; index++) {
      const configuration: ApiConfiguration | undefined = configurations[index];
      if (configuration !== undefined && configuration.isEnabled) {
        return configuration;
      }
    }
    return undefined;
  }

  public createConfiguration(apiKey: string, isEnabled: boolean): ApiConfiguration {
    const timestamp: number = Date.now();
    return ApiConfiguration.create(`api_${timestamp}`, apiKey, '', isEnabled, timestamp, timestamp);
  }
}
