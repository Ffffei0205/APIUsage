/**
 * 项目名称: ApiUsage
 * 文件名称: hdsListItem
 * 创建时间: 2026-08-14 22:17
 * 创建人：  @author Ffffei
 * 文件描述: TODO
 */
import { HdsListItemCard, IconSize, PrefixIcon,
  SuffixArrow,
  SuffixBadgeAndArrow, SuffixButton, SuffixText } from "@kit.UIDesignKit";
import { SuffixItem } from "@hms.hds.hdsBaseComponent";
import { SymbolGlyphModifier } from "@kit.ArkUI";


@Component
export struct hdsListItem {
  // ===== 前缀（图标）=====
  /** 左侧图标资源（symbol），默认铃铛 */
  @Prop prefixResource: Resource = $r('sys.symbol.bell');
  /** 图标颜色，默认次级图标色 */
  @Prop prefixColor: ResourceColor = $r('sys.color.icon_secondary');
  // ===== 文本 =====
  /** 主标题，必传的语义字段（不传则显示空） */
  @Prop title: ResourceStr = '';
  /** 副标题，可选：显示在主标题下方的小字 */
  @Prop subTitle: ResourceStr = '';
  /** 描述文字，可选：显示在右侧后缀位置 */
  @Prop desc: ResourceStr = '';
  // ===== 后缀（右侧）=====
  /** 角标数字，>0 时显示红色角标 + 箭头（如“内容上新”未读数） */
  @Prop badgeNum: number = 0;
  /** 按钮文字，有值时后缀显示为按钮（优先级最高） */
  @Prop buttonTitle: ResourceStr = '';
  /** 行高，默认 56vp（官方用的是资源 float，你项目没有就先写死） */
  @Prop itemHeight: Dimension = 56;
  /** 点击回调，可选：由调用方决定点了之后干什么 */
  handleClickAction?: () => void;

  getSuffixItem(): SuffixItem {
    if (this.buttonTitle) {
      return new SuffixButton({ text: this.buttonTitle });
    } else if (this.badgeNum) {
      return new SuffixBadgeAndArrow({
        badgeValue: this.badgeNum,
        badgeColor: $r('sys.color.ohos_id_color_badge_red'),
        textColor: $r('sys.color.font_on_primary'),
      }, {
        color: $r('sys.color.icon_fourth'),
      });
    } else if (this.desc) {
      return new SuffixText({ text: this.desc });
    } else {
      return new SuffixArrow({ color: $r('sys.color.icon_fourth') });
    }
  }

  build() {
    HdsListItemCard({
      prefixItem: this.prefixResource ? new PrefixIcon({
        iconSize: IconSize.SYSTEM_ICON,
        iconValue: {
          symbol: new SymbolGlyphModifier(this.prefixResource)
            .fontColor([this.prefixColor]),
        }
      }) : undefined,
      textItem: {
        primaryText: {
          text: this.title,
        },
        secondaryText: this.subTitle ? { text: this.subTitle } : undefined,
      },
      suffixItem: this.getSuffixItem(),
      // 以下都是外观参数：圆角、边距、高度、背景
      cardBorderRadius: $r('sys.float.corner_radius_level8'),
      cardPrefixMargin: 0,
      cardSuffixMargin: 0,
      cardHeight: this.itemHeight,
      cardBackgroundColor: $r('sys.color.ohos_id_color_background_transparent'),
      onClick: this.handleClickAction ? () => {
        this.handleClickAction?.()
      } : undefined

    })
  }
}