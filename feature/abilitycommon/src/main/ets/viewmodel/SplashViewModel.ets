/**
 * 项目名称: ApiUsage
 * 文件名称: SplashViewModel
 * 创建时间: 2026-08-14 21:45
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */

import { PageContext, PageEnum, StorageKey } from 'common';

export class SplashViewModel {
  private static instance: SplashViewModel;

  private constructor() {
  }

  public static getInstance(): SplashViewModel {
    if (!SplashViewModel.instance) {
      SplashViewModel.instance = new SplashViewModel();
    }
    return SplashViewModel.instance;
  }

  public sendEvent<T>(event: SplashEventParam<T>): void {
    if (event.type === SplashEventType.JUMP_TO_MAIN) {
      this.jumpToMainPage();
    }
  }

  private jumpToMainPage(): void {
    AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT)?.replacePage({
      routerName: PageEnum.MAIN_PAGE,
    }, false);
  }
}

export enum SplashEventType {
  JUMP_TO_MAIN = 'jumpToMainPage',
}

export interface SplashEventParam<T> {
  type: SplashEventType;
  param?: T;
}