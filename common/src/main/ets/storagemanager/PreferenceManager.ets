/**
 * 项目名称: ApiUsage
 * 文件名称: PreferenceManager
 * 创建时间: 2026-05-26 14:32
 * 创建人：  @author Ffffei
 * 文件描述: 用户首选项类，以后所有的用户首选项存储一律使用此类
 */
import { preferences, ValueType } from "@kit.ArkData";
import { StorageKey } from '../constants/CommonEnums';
import { UIContext } from "@kit.ArkUI";
import Logger from "../utils/Logger";


const TAG: string = '[PreferenceManager]';
const PREFERENCES_NAME: string = 'hanbaoStore'

export class PreferenceManager {
  private static instance: PreferenceManager;
  private preference?: preferences.Preferences
  private canUseGSKV: boolean = false

  constructor() {
    this.initPreference(PREFERENCES_NAME)
  }

  public static getInstance(): PreferenceManager {

    /*
     * 对外提供获取实例的能力
     * */

    if (!PreferenceManager.instance) {
      PreferenceManager.instance = new PreferenceManager()
    }
    return PreferenceManager.instance
  }

  initPreference(storeName: string) {
    // 从AppStorage获取UIContext, 提供给preferences.getPreferencesSync()
    const uiContext: UIContext = AppStorage.get<UIContext>(StorageKey.UI_CONTEXT) as UIContext

    // 判断是否可以用GSKV存储模式
    if (preferences.isStorageTypeSupported(preferences.StorageType.GSKV)) {
      Logger.info(TAG, 'This platform can use GSKV, now use GSKV');

      this.canUseGSKV = true
      let options: preferences.Options = { name: storeName, storageType: preferences.StorageType.GSKV };
      try {
        this.preference = preferences.getPreferencesSync(uiContext.getHostContext() as Context, options)
      } catch (error) {
        Logger.error(TAG, `GSKV getPreferences failed, err code:${error.code},msg:${error.message}`);
      }
    } else {
      Logger.info(TAG, 'This platform can not use GSKV, now use XML');

      this.canUseGSKV = false
      let options: preferences.Options = { name: storeName, storageType: preferences.StorageType.XML }
      try {
        this.preference = preferences.getPreferencesSync(uiContext.getHostContext() as Context, options)
      } catch (error) {
        Logger.error(TAG, `XML getPreferences failed, err code:${error.code},msg:${error.message}`);
      }
    }
  }

  // 保存数据 保存后调用saveValue()方法持久化
  public setValue<T>(key: string, value: T) {
    if (this.preference) {
      try {
        this.preference.putSync(key, JSON.stringify(value))
        this.saveValue
      } catch (error) {
        Logger.error(TAG, `Preferences put ${key} failed, err code:${error?.code},msg:${error?.message}`)
      }
    } else {
      this.initPreference(PREFERENCES_NAME)
      this.setValue<T>(key, value)
    }
  }

  // 获取数据
  public getValue<T>(key: string, defaultValue?: ValueType): T | null {
    if (this.preference) {
      //获取数据
      try {
        let result = this.preference.getSync(key, defaultValue)
        let value: T | null = null
        if (result) {
          value = JSON.parse(result as string) as T
        }
        return value
      } catch (error) {
        Logger.error(TAG, `Preferences get ${key} failed. err code:${error.code},msg:${error.message}`);
        return null
      }
    } else {
      //创建实例后继续获取数据
      this.initPreference(PREFERENCES_NAME)
      return this.getValue<T>(key, defaultValue)
    }
  }

  // 查询是否包含此数据
  public hasValue(key: string): boolean {
    if (this.preference) {
      try {
        return this.preference.hasSync(key)
      } catch (error) {
        Logger.error(TAG, `Preferences hasValue ${key} failed. err code:${error.code},msg:${error.message}`);
        return false
      }
    } else {
      this.initPreference(PREFERENCES_NAME)
      return this.hasValue(key)
    }
  }

  // 删除此首选项
  public deleteValue(key: string) {
    if (this.preference) {
      try {
        this.preference.deleteSync(key)
        this.saveValue()
      } catch (error) {
        Logger.error(TAG, `Preferences deleteValue ${key} failed. err code:${error.code},msg:${error.message}`);
      }
    } else {
      this.initPreference(PREFERENCES_NAME)
      this.deleteValue(key)
    }
  }

  // 调用接口持久化
  saveValue() {
    // 持久化数据, 如果是GSKV,则不需要进行flush()
    if (!this.canUseGSKV) {
      this.preference?.flush().catch((err: BusinessError) => {
        Logger.error(TAG, `Preferences flush failed.err code:${err.code},msg:${err.message}`)
      })
    }
  }
}