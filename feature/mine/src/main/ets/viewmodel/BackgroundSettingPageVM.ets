import { AppThemeMode, BaseVM, BaseVMEvent, StorageKey, ThemeManager } from 'common';
import { BackgroundSettingState } from './BackgroundSettingState';

export class BackgroundSettingPageVM extends BaseVM<BackgroundSettingState> {
  private static instance: BackgroundSettingPageVM;

  private constructor() {
    super(new BackgroundSettingState());
  }

  public static getInstance(): BackgroundSettingPageVM {
    if (!BackgroundSettingPageVM.instance) {
      BackgroundSettingPageVM.instance = new BackgroundSettingPageVM();
    }
    return BackgroundSettingPageVM.instance;
  }

  public sendEvent(event: BaseVMEvent): void {
    if (event instanceof InitializeBackgroundSettingEvent) {
      this.initialize();
    } else if (event instanceof SelectThemeModeEvent) {
      this.selectThemeMode(event.themeMode);
    }
  }

  private initialize(): void {
    const savedThemeMode: AppThemeMode | undefined = AppStorage.get<AppThemeMode>(StorageKey.CURRENT_COLOR_MODE);
    if (savedThemeMode === AppThemeMode.LIGHT || savedThemeMode === AppThemeMode.DARK ||
      savedThemeMode === AppThemeMode.SYSTEM) {
      this.state.selectedThemeMode = savedThemeMode;
    } else {
      this.state.selectedThemeMode = AppThemeMode.SYSTEM;
    }
  }

  private selectThemeMode(themeMode: AppThemeMode): void {
    ThemeManager.setThemeMode(themeMode);
    this.state.selectedThemeMode = themeMode;
  }
}

export class InitializeBackgroundSettingEvent implements BaseVMEvent {
}

export class SelectThemeModeEvent implements BaseVMEvent {
  public themeMode: AppThemeMode;

  public constructor(themeMode: AppThemeMode) {
    this.themeMode = themeMode;
  }
}
