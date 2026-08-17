/**
 * 项目名称: ApiUsage
 * 文件名称: RouterParams
 * 创建时间: 2026-08-11 22:08
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */
import { HdsTabsController } from "@kit.UIDesignKit";


interface BasicRouterParams {
  title: string;
  id: number;
}







/**
 * xxxHomeView跳转到具体的xxxView时的路由参数，即从导航壳，目的地时具体内容
 */
export interface HomeContentParams {
  scroller: Scroller,
  homeTabController: HdsTabsController
}