/**
 * 项目名称: ApiUsage
 * 文件名称: TabBarModel
 * 创建时间: 2026-08-14 19:57
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */

interface BarItem {
  iconResource: Resource,
  label: ResourceStr,
  normalColor?: ResourceColor;
  selectedColor: ResourceColor;
}

const BAR_ITEMS: BarItem[] = [
  {
    iconResource: $r('app.media.ic_balance'),
    label: $r('app.string.tab_balance'),
    normalColor: $r('sys.color.font_primary'),
    selectedColor: $r('app.color.app_icon_pressed_color'),
  },
  {
    iconResource: $r('app.media.ic_settings'),
    label: $r('app.string.tab_settings'),
    normalColor: $r('sys.color.font_primary'),
    selectedColor: $r('app.color.app_icon_pressed_color'),
  }
]

export class TabsBarModel {
  //缓存Tab列表，最后由下面的static函数提供诶外部
  private static cachedTabBarStyleList?: BottomTabBarStyle[];

  public static getTabBarByPage(): BottomTabBarStyle[] {
    /**
     * 给外部使用的函数，最后可以提供出一个BottomTabBarStyle的数组，内含了所有TabUI
     */
    if (!TabsBarModel.cachedTabBarStyleList) {
      const tabBarStyleList: BottomTabBarStyle[] = [] //先创建一个空的数组，用于TabUI存储
      BAR_ITEMS.forEach((item: BarItem) => {  // 对本文件下已经定义好的tab信息做遍历

        const tabBarStyle = new BottomTabBarStyle(item.iconResource, item.label)
          .iconStyle({
            unselectedColor:item.normalColor,
            selectedColor: item.selectedColor
          })
          .labelStyle({
            unselectedColor: item.normalColor,
            selectedColor: item.selectedColor,
          });
        //到此都是new了一个BottomTabBarStyle对象，只包含一个tabUI的内容

        tabBarStyleList.push(tabBarStyle);  // 加入上面的空数组，进行下一轮遍历
      });

      TabsBarModel.cachedTabBarStyleList = tabBarStyleList; //将上面遍历之后的结果更新至缓存列表
    }
    return TabsBarModel.cachedTabBarStyleList;  //对外提供缓存数组
  }
}