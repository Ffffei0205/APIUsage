/**
 * 项目名称: ApiUsage
 * 文件名称: AboutState
 * 文件描述: 关于和反馈页面状态
 */

import { BaseState } from 'common';

@Observed
export class AboutState extends BaseState {
  public appVersion: string = '';
}
