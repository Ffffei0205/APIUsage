import { BaseState } from 'common';

export enum SettingItemId {
  BACKGROUND = 'background',
}

@Observed
export class SettingState extends BaseState {
  public itemGroups: SettingItemGroup[] = [];
}

@Observed
export class SettingItemGroup {
  public id: number = 0;
  public items: SettingItem[] = [];

  public static of(id: number, items: SettingItem[]): SettingItemGroup {
    const group: SettingItemGroup = new SettingItemGroup();
    group.id = id;
    group.items = items;
    return group;
  }
}

@Observed
export class SettingItem {
  public id: SettingItemId = SettingItemId.BACKGROUND;
  public title: ResourceStr = '';
  public symbolSrc: Resource = $r('sys.symbol.gearshape');

  public static of(id: SettingItemId, title: ResourceStr, symbolSrc: Resource): SettingItem {
    const item: SettingItem = new SettingItem();
    item.id = id;
    item.title = title;
    item.symbolSrc = symbolSrc;
    return item;
  }
}
