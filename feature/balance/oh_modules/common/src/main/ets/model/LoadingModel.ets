/**
 * 项目名称: ApiUsage
 * 文件名称: LoadingModel
 * 创建时间: 2026-08-11 21:01
 * 创建人：  @author Ffffei
 * 文件描述: 加载状态数据类
 */

import { LoadingStatus } from '../constant/CommonEnums';

@Observed
export class LoadingModel {
  public loadingStatus: LoadingStatus = LoadingStatus.OFF;
  public loadingMoreStatus: LoadingStatus = LoadingStatus.OFF;
  public hasNextPage: boolean = false;

  public constructor(loadingStatus?: LoadingStatus) {
    this.loadingStatus = loadingStatus || LoadingStatus.OFF;
  }
}