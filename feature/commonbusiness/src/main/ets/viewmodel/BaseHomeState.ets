/**
 * 项目名称: ApiUsage
 * 文件名称: BaseHomeState
 * 创建时间: 2026-08-11 22:05
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */

import { BaseState, LoadingModel } from 'common';
import { TopNavigationData } from '../model/TopNavigationData';

@Observed
export class BaseHomeState extends BaseState {
  public loadingModel: LoadingModel = new LoadingModel();                  // 加载状态机
  public topNavigationData: TopNavigationData = new TopNavigationData();   // 标题栏数据（含滚动模糊开关）
  public scroller: Scroller = new Scroller();                              // 页面滚动控制器
  public hasEdgeEffect: boolean = true;                                    // 边缘回弹开关（默认 true 与现状一致，之后由 VM 控制）
}
