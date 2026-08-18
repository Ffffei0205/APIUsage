/**
 * 项目名称: ApiUsage
 * 文件名称: AboutVM
 * 文件描述: 关于和反馈页面数据驱动
 */

import { bundleManager } from '@kit.AbilityKit';
import { BaseVM, BaseVMEvent } from 'common';
import { AboutState } from './AboutState';

export class AboutVM extends BaseVM<AboutState> {
  private static instance: AboutVM;

  private constructor() {
    super(new AboutState());
  }

  public static getInstance(): AboutVM {
    if (!AboutVM.instance) {
      AboutVM.instance = new AboutVM();
    }
    return AboutVM.instance;
  }

  public sendEvent(event: BaseVMEvent): void {
    if (event instanceof InitializeAboutEvent) {
      this.loadAppVersion();
    }
  }

  private loadAppVersion(): void {
    const bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoForSelfSync(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    this.state.appVersion = `${bundleInfo.versionName} (${bundleInfo.versionCode})`;
  }
}

export class InitializeAboutEvent implements BaseVMEvent {
}
