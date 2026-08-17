/**
 * 项目名称: ApiUsage
 * 文件名称: BaseHomeView
 * 创建时间: 2026-08-11 22:05
 * 创建人：  @author Ffffei
 * 文件描述: 加载状态机外壳（@BuilderParam 插槽）
 */

import type { LoadingModel } from 'common';
import {
  GlobalInfoModel,
  LoadingFailedView,
  LoadingStatus,
  LoadingView,
  NoNetworkView,
  StorageKey,
} from 'common';

@Component
export struct BaseHomeView {
  @Prop @Require loadingModel: LoadingModel;
  @BuilderParam @Require contentView: () => void;
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel = new GlobalInfoModel();
  reloadData?: Function;

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.loadingModel.loadingStatus === LoadingStatus.SUCCESS) {
        this.contentView()
      } else if (this.loadingModel.loadingStatus === LoadingStatus.FAILED) {
        LoadingFailedView(this.globalInfoModel.widthBreakpoint, () => {
          this.reloadData?.();
        })
      } else if (this.loadingModel.loadingStatus === LoadingStatus.LOADING) {
        LoadingView(this.globalInfoModel.widthBreakpoint)
      } else if (this.loadingModel.loadingStatus === LoadingStatus.NO_NETWORK) {
        NoNetworkView(this.globalInfoModel.widthBreakpoint, () => {
          this.reloadData?.();
        })
      }
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .width('100%')
    .height('100%')
  }
}