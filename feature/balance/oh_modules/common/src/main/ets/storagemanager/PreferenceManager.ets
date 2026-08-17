import { preferences, ValueType } from "@kit.ArkData";
import { StorageKey } from '../constant/CommonEnums';
import { UIContext } from "@kit.ArkUI";
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from "../util/Logger";


const TAG: string = '[PreferenceManager]';
const PREFERENCES_NAME: string = 'hanbaoStore'

export class PreferenceManager {
  private static instance: PreferenceManager;
  private preference?: preferences.Preferences
  private canUseGSKV: boolean = false
  private initialized: boolean = false

  private constructor() {
  }

  public static getInstance(): PreferenceManager {
    if (!PreferenceManager.instance) {
      PreferenceManager.instance = new PreferenceManager()
    }
    return PreferenceManager.instance
  }

  public initPreference(storeName: string) {
    if (this.initialized && this.preference) {
      return
    }
    const uiContext: UIContext | undefined = AppStorage.get<UIContext>(StorageKey.UI_CONTEXT)
    if (uiContext == undefined) {
      Logger.error(TAG, 'UIContext is not initialized in AppStorage')
      return
    }

    if (preferences.isStorageTypeSupported(preferences.StorageType.GSKV)) {
      Logger.info(TAG, 'This platform can use GSKV, now use GSKV');
      this.canUseGSKV = true
      let options: preferences.Options = { name: storeName, storageType: preferences.StorageType.GSKV };
      try {
        this.preference = preferences.getPreferencesSync(uiContext.getHostContext(), options)
      } catch (error) {
        const err: BusinessError = error
        Logger.error(TAG, 'GSKV getPreferences failed, err code:' + err.code + ',msg:' + err.message.toString());
      }
    } else {
      Logger.info(TAG, 'This platform can not use GSKV, now use XML');
      this.canUseGSKV = false
      let options: preferences.Options = { name: storeName, storageType: preferences.StorageType.XML }
      try {
        this.preference = preferences.getPreferencesSync(uiContext.getHostContext(), options)
      } catch (error) {
        const err: BusinessError = error
        Logger.error(TAG, 'XML getPreferences failed, err code:' + err.code + ',msg:' + err.message.toString());
      }
    }
    this.initialized = true
  }

  public setValue<T>(key: string, value: T) {
    if (this.preference) {
      try {
        this.preference.putSync(key, JSON.stringify(value))
        this.saveValue()
      } catch (error) {
        const err: BusinessError = error
        Logger.error(TAG, 'Preferences put ' + key + ' failed, err code:' + err.code + ',msg:' + err.message.toString())
      }
    } else {
      Logger.error(TAG, 'PreferenceManager is not initialized, cannot set value for ' + key)
    }
  }

  public getValue<T>(key: string, defaultValue?: ValueType): T | null {
    if (this.preference) {
      try {
        let result = this.preference.getSync(key, defaultValue)
        let value: T | null = null
        if (result) {
          value = JSON.parse(result.toString())
        }
        return value
      } catch (error) {
        const err: BusinessError = error
        Logger.error(TAG, 'Preferences get ' + key + ' failed. err code:' + err.code + ',msg:' + err.message.toString());
        return null
      }
    } else {
      Logger.error(TAG, 'PreferenceManager is not initialized, cannot get value for ' + key)
      return null
    }
  }

  public hasValue(key: string): boolean {
    if (this.preference) {
      try {
        return this.preference.hasSync(key)
      } catch (error) {
        const err: BusinessError = error
        Logger.error(TAG, 'Preferences hasValue ' + key + ' failed. err code:' + err.code + ',msg:' + err.message.toString());
        return false
      }
    } else {
      Logger.error(TAG, 'PreferenceManager is not initialized, cannot check value for ' + key)
      return false
    }
  }

  public deleteValue(key: string) {
    if (this.preference) {
      try {
        this.preference.deleteSync(key)
        this.saveValue()
      } catch (error) {
        const err: BusinessError = error
        Logger.error(TAG, 'Preferences deleteValue ' + key + ' failed. err code:' + err.code + ',msg:' + err.message.toString());
      }
    } else {
      Logger.error(TAG, 'PreferenceManager is not initialized, cannot delete value for ' + key)
    }
  }

  saveValue() {
    if (!this.canUseGSKV) {
      this.preference?.flush().catch((err: BusinessError) => {
        Logger.error(TAG, 'Preferences flush failed.err code:' + err.code + ',msg:' + err.message.toString())
      })
    }
  }
}
