/**
 * 可持久化的 API 配置。apiType 预留为空字符串时，当前按 DeepSeek 处理。
 */
export class ApiConfiguration {
  public id: string = '';
  public apiKey: string = '';
  public apiType: string = '';
  public isEnabled: boolean = false;
  public createdAt: number = 0;
  public updatedAt: number = 0;

  public static create(id: string, apiKey: string, apiType: string, isEnabled: boolean,
    createdAt: number, updatedAt: number): ApiConfiguration {
    const configuration: ApiConfiguration = new ApiConfiguration();
    configuration.id = id;
    configuration.apiKey = apiKey;
    configuration.apiType = apiType;
    configuration.isEnabled = isEnabled;
    configuration.createdAt = createdAt;
    configuration.updatedAt = updatedAt;
    return configuration;
  }
}
