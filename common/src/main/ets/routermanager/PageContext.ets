/**
 * 项目名称: ApiUsage
 * 文件名称: PageContext
 * 创建时间: 2026-08-11 21:02
 * 创建人：  @author Ffffei
 * 文件描述: NavPathStack 封装，作为路由跳转的工具
 * 本质是 pathStack.pushPath/pop/replacePath/clear等方法
 */

import { PageEnum } from '../model/PageEnum';
import { Logger } from '../util';

export interface RouterParam {
  routerName: PageEnum;
  param?: object;
}

export interface IPageContext {
  openPage(data: RouterParam, animated?: boolean): void;
  popPage(animated?: boolean): void;
  replacePage(data: RouterParam, animated?: boolean): void;
}

export class PageContext implements IPageContext {
  private readonly pathStack: NavPathStack;

  constructor() {
    this.pathStack = new NavPathStack();
  }

  public get navPathStack(): NavPathStack {
    return this.pathStack;
  }

  public openPage(data: RouterParam, animated: boolean = true): void {
    try {
      this.pathStack.pushPath({
        name: data.routerName,
        param: data.param,
      }, animated);
    } catch (err) {
      Logger.error('PageContext', `Open Page ${data.routerName} failed.`);
    }
  }

  public popPage(animated: boolean = true): void {
    try {
      this.pathStack.pop(animated);
    } catch (err) {
      Logger.error('PageContext', `Pop Page failed.`);
    }
  }

  public replacePage(data: RouterParam, animated: boolean = true): void {
    try {
      this.pathStack.replacePath({
        name: data.routerName,
        param: data.param,
      }, animated);
    } catch (err) {
      Logger.error('PageContext', `Replace Page failed.`);
    }
  }

  public clear(animated: boolean = true): void {
    this.pathStack.clear(animated);
  }
}