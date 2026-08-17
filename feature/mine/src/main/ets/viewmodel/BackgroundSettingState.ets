import { AppThemeMode, BaseState } from 'common';

@Observed
export class BackgroundSettingState extends BaseState {
  public selectedThemeMode: AppThemeMode = AppThemeMode.SYSTEM;
}
