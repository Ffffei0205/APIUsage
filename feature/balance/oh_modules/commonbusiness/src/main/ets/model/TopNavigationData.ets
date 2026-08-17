/**
 * 项目名称: ApiUsage
 * 文件名称: TopNavigationData
 * 创建时间: 2026-08-14 23:42
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */
import { TitleBarStyleOptions } from "@kit.UIDesignKit";


@Observed
export class TopNavigationData{
  public title: ResourceStr = '';
  public isFullScreen?: boolean = true;
  public titleColor?: ResourceStr = $r('sys.color.font_primary');
  public isBlur?: boolean = false;                     // 上滑后是否启用模糊标题栏
  public onBackClick?: () => void;
  public hdsTitleBarStyle?: TitleBarStyleOptions;      // VM 计算后的 HDS 标题栏样式
}