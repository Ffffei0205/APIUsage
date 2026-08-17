/**
 * 项目名称: ApiUsage
 * 文件名称: HomeView
 * 创建时间: 2026-08-12 21:02
 * 创建人：  @author Ffffei
 * 文件描述: 主页面组件
 */
import { GlobalInfoModel, StorageKey, Logger, PageContext } from "common";
import { hdsMaterial, HdsNavDestination, HdsTabs, HdsTabsController } from "@kit.UIDesignKit";
import { TabsBarModel } from "../model/TabBarModel";
import { MineHomeView } from "mine";
import { BalanceHomeView } from "balance";


const TAG: string = '[HomeView]';


@Component
export struct HomeView {
  @StorageProp(StorageKey.GLOBAL_INFO) globalInfoModel: GlobalInfoModel =
    AppStorage.get(StorageKey.GLOBAL_INFO) ?? new GlobalInfoModel();
  @StorageLink(StorageKey.HOME_PAGE_CONTEXT) pageContext: PageContext =
    AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT) ?? new PageContext();
  private tabsBar: BottomTabBarStyle[] = TabsBarModel.getTabBarByPage() ?? [];
  private tabController: HdsTabsController = new HdsTabsController();

  @Builder
  TabContentsBuilder() {
    Repeat(this.tabsBar).each((repeatItem: RepeatItem<BottomTabBarStyle>) => {
      TabContent() {
        // 根据 repeatItem.index 渲染对应页面
        if (repeatItem.index == 0) {
          BalanceHomeView()
        } else if (repeatItem.index == 1) {
          MineHomeView()
        }
      }
      .tabBar(repeatItem.item)
    })
  }

  build() {
    HdsTabs({ controller: this.tabController }) {
      this.TabContentsBuilder()
    }
    .scrollable(false)
    .vertical(false)
    .barOverlap(true)
    .barPosition(BarPosition.End)
    .barFloatingStyle({
      barWidth: { smallWidth: 150 },
      barBottomMargin: this.globalInfoModel.naviIndicatorHeight,
      systemMaterialEffect: {
        materialType: hdsMaterial.MaterialType.IMMERSIVE,
        materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
      }
    })
  }
}
