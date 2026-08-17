import { BaseVM, BaseVMEvent, PageContext, PageEnum, StorageKey } from 'common';
import { SettingItem, SettingItemGroup, SettingItemId, SettingState } from './SettingState';

export class SettingPageVM extends BaseVM<SettingState> {
  private static instance: SettingPageVM;

  private constructor() {
    super(new SettingState());
  }

  public static getInstance(): SettingPageVM {
    if (!SettingPageVM.instance) {
      SettingPageVM.instance = new SettingPageVM();
    }
    return SettingPageVM.instance;
  }

  public sendEvent(event: BaseVMEvent): void {
    if (event instanceof InitializeSettingEvent) {
      this.initialize();
    } else if (event instanceof SelectSettingItemEvent) {
      this.handleItemSelection(event.itemId);
    }
  }

  private initialize(): void {
    const backgroundItem: SettingItem = SettingItem.of(
      SettingItemId.BACKGROUND,
      $r('app.string.background_setting'),
      $r('sys.symbol.gearshape')
    );
    const generalGroup: SettingItemGroup = SettingItemGroup.of(0, [backgroundItem]);
    this.state.itemGroups = [generalGroup];
  }

  private handleItemSelection(itemId: SettingItemId): void {
    if (itemId === SettingItemId.BACKGROUND) {
      this.openBackgroundSetting();
    }
  }

  private openBackgroundSetting(): void {
    const pageContext: PageContext | undefined = AppStorage.get<PageContext>(StorageKey.HOME_PAGE_CONTEXT);
    pageContext?.openPage({
      routerName: PageEnum.BACKGROUND_SETTING_VIEW,
    }, true);
  }
}

export class InitializeSettingEvent implements BaseVMEvent {
}

export class SelectSettingItemEvent implements BaseVMEvent {
  public itemId: SettingItemId;

  public constructor(itemId: SettingItemId) {
    this.itemId = itemId;
  }
}
