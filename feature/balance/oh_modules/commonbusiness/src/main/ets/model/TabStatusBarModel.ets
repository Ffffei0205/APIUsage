/**
 * 项目名称: ApiUsage
 * 文件名称: TabStatusBarModel
 * 创建时间: 2026-08-11 22:08
 * 创建人：  @author Ffffei
 * 文件描述: 定义TabBarType,主要是分别当前在哪个TAB,还有就是状态栏要不要变化
 */

// TabContent views is dark StatusBar or not.
// 只有两个 tab，数组长度必须和 TabBarType 一一对应（余额、我的）
export const TAB_CONTENT_STATUSES: boolean[] = [false, false];


/**
 * 两个 tab，编号 0~1。编号顺序必须和底部 tab 栏的显示顺序一致。
 */
export enum TabBarType {
  HOME = 0, // 余额
  MINE = 1, // 我的
}
