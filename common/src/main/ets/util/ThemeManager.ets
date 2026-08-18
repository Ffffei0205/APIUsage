import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { StorageKey } from '../constant/CommonEnums';
import { PreferenceManager } from '../storagemanager/PreferenceManager';
import Logger from './Logger';

const TAG: string = '[ThemeManager]';
export enum AppThemeMode {
  SYSTEM = 'system',
  LIGHT = 'light',
  DARK = 'dark',
}

export class ThemeManager {
  private static abilityContext: common.UIAbilityContext | undefined = undefined;
  private static currentThemeMode: AppThemeMode = AppThemeMode.SYSTEM;
  private static preferenceManager: PreferenceManager = PreferenceManager.getInstance();

  public static initialize(context: common.UIAbilityContext): void {
    ThemeManager.abilityContext = context;
  }

  public static restoreThemeMode(): void {
    ThemeManager.preferenceManager.initPreference();
    const savedThemeMode: AppThemeMode | null =
      ThemeManager.preferenceManager.getValue<AppThemeMode>(StorageKey.CURRENT_COLOR_MODE);
    if (savedThemeMode === AppThemeMode.SYSTEM || savedThemeMode === AppThemeMode.LIGHT ||
      savedThemeMode === AppThemeMode.DARK) {
      ThemeManager.currentThemeMode = savedThemeMode;
    } else {
      ThemeManager.currentThemeMode = AppThemeMode.SYSTEM;
    }
    AppStorage.setOrCreate(StorageKey.CURRENT_COLOR_MODE, ThemeManager.currentThemeMode);
    ThemeManager.applyThemeMode();
  }

  public static setThemeMode(themeMode: AppThemeMode): void {
    ThemeManager.currentThemeMode = themeMode;
    ThemeManager.preferenceManager.setValue<AppThemeMode>(StorageKey.CURRENT_COLOR_MODE, themeMode);
    AppStorage.setOrCreate(StorageKey.CURRENT_COLOR_MODE, themeMode);
    ThemeManager.applyThemeMode();
  }

  private static applyThemeMode(): void {
    const context: common.UIAbilityContext | undefined = ThemeManager.abilityContext;
    if (context === undefined) {
      Logger.error(TAG, 'UIAbilityContext is not initialized');
      return;
    }

    let colorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
    if (ThemeManager.currentThemeMode === AppThemeMode.LIGHT) {
      colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
    } else if (ThemeManager.currentThemeMode === AppThemeMode.DARK) {
      colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    }

    try {
      context.getApplicationContext().setColorMode(colorMode);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setColorMode failed, code: ${err.code}, message: ${err.message}`);
    }
  }
}
