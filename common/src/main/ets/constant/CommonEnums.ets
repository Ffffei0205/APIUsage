/**
 * 项目名称: ApiUsage
 * 文件名称: CommonEnums
 * 创建时间: 2026-05-26 14:40
 * 创建人：  @author Ffffei
 * 文件描述: 一些重要的枚举类
 */

/**
 * 加载状态枚举
 */
export enum LoadingStatus {
  IDLE = 'idle',  // 待机
  OFF = 'off',   // 停止
  LOADING = 'loading',  // 加载中
  SUCCESS = 'success',  //加载成功
  FAILED = 'failed',  //加载失败
  NO_NETWORK = 'no_network',  //没有网络
  EMPTY_DATA = 'empty_data',  //没有数据
}



export enum StorageKey {
  UI_CONTEXT = 'ApiUsage_UIContext',  //UI CONTEXT
  GLOBAL_INFO = 'ApiUsage_GlobalInfoModel', // 主要存一些全局信息
  CURRENT_COLOR_MODE = 'currentColorMode',
  DS_API_KEY = 'ApiUsage_api_key',  //  DeepSeek API

  CURRENT_TAB = 'ApiUsage_CurrentTabIndex', // 当前的tab Index
  MINE_PAGE_CONTEXT = 'ApiUsage_MinePageContext', // “我的”页面Context
  HOME_PAGE_CONTEXT = 'ApiUsage_PageContext',
  BALANCE_PAGE_CONTEXT = 'ApiUsage_BalancePageContext', // balance tab stack
  // COMPONENT_PAGE_CONTEXT = 'hmos_world_ComponentListPageContext',
  // SAMPLE_PAGE_CONTEXT = 'hmos_world_SamplePageContext',
  // EXPLORATION_PAGE_CONTEXT = 'hmos_world_ExplorationPageContext',

  // IS_SIDEBAR_LAYOUT = 'hmos_world_isSideBarLayout',

}
