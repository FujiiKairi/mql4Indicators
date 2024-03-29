//+----------------------------------------------------------------------------+
//|                                                Indicator - KUROHUNEPO.mq4 |
//|                                                                            |
//|                                                                            |
//+----------------------------------------------------------------------------+

//--- Declaration of Constants
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I0130 "
#define OBJNAME_BUY OBJNAME_PREFIX + "BUY "
#define OBJNAME_SELL OBJNAME_PREFIX + "SELL "
#define OUTPUT_CONSOLE LEVEL_NONE
#define OUTPUT_FILE LEVEL_NONE
#define OUTPUT_TESTING false
//+----------------------------------------------------------------------------+


//--- Program Properties
#property strict
#property link PROPERTY_LINK
#property copyright PROPERTY_COPYRIGHT
#property description PROPERTY_DESCRIPTION
#property indicator_separate_window
//+----------------------------------------------------------------------------+


//--- Declaration of Constants (#define)
#define OBJNAME_COPYRIGHT OBJNAME_PREFIX + "COPYRIGHT"
#define COPYRIGHT_COLOR_BLACK C'32,32,32'
#define COPYRIGHT_COLOR_WHITE C'224,224,224'
#define COPYRIGHT_FONT "Comic Sans MS"
#define COPYRIGHT_SIZE 14
//+----------------------------------------------------------------------------+


//--- Program Properties (#property)
#property strict
//+----------------------------------------------------------------------------+


//--- Including Files (#include)
#include <stdlib.mqh>
//+----------------------------------------------------------------------------+


//--- Conditional Compilation (#ifdef, #ifndef, #else, #endif)
#ifndef MQL4
#define PROPERTY_COPYRIGHT ""
#define OBJNAME_PREFIX ""
#include "MQL4Common.mqh"
#include "MQL4Log.mqh"
#include "MQL4Dependency.mqh"
#endif 
//+----------------------------------------------------------------------------+


//--- Enumerations
enum ENUM_HOUR
{
    HOUR_0 = 0,     // 0
    HOUR_1 = 1,     // 1
    HOUR_2 = 2,     // 2
    HOUR_3 = 3,     // 3
    HOUR_4 = 4,     // 4
    HOUR_5 = 5,     // 5
    HOUR_6 = 6,     // 6
    HOUR_7 = 7,     // 7
    HOUR_8 = 8,     // 8
    HOUR_9 = 9,     // 9
    HOUR_10 = 10,   // 10
    HOUR_11 = 11,   // 11
    HOUR_12 = 12,   // 12
    HOUR_13 = 13,   // 13
    HOUR_14 = 14,   // 14
    HOUR_15 = 15,   // 15
    HOUR_16 = 16,   // 16
    HOUR_17 = 17,   // 17
    HOUR_18 = 18,   // 18
    HOUR_19 = 19,   // 19
    HOUR_20 = 20,   // 20
    HOUR_21 = 21,   // 21
    HOUR_22 = 22,   // 22
    HOUR_23 = 23    // 23
};
//+----------------------------------------------------------------------------+

enum ENUM_MINUTE
{
    MINUTE_0 = 0,   // 00
    MINUTE_1 = 1,   // 01
    MINUTE_2 = 2,   // 02
    MINUTE_3 = 3,   // 03
    MINUTE_4 = 4,   // 04
    MINUTE_5 = 5,   // 05
    MINUTE_6 = 6,   // 06
    MINUTE_7 = 7,   // 07
    MINUTE_8 = 8,   // 08
    MINUTE_9 = 9,   // 09
    MINUTE_10 = 10, // 10
    MINUTE_11 = 11, // 11
    MINUTE_12 = 12, // 12
    MINUTE_13 = 13, // 13
    MINUTE_14 = 14, // 14
    MINUTE_15 = 15, // 15
    MINUTE_16 = 16, // 16
    MINUTE_17 = 17, // 17
    MINUTE_18 = 18, // 18
    MINUTE_19 = 19, // 19
    MINUTE_20 = 20, // 20
    MINUTE_21 = 21, // 21
    MINUTE_22 = 22, // 22
    MINUTE_23 = 23, // 23
    MINUTE_24 = 24, // 24
    MINUTE_25 = 25, // 25
    MINUTE_26 = 26, // 26
    MINUTE_27 = 27, // 27
    MINUTE_28 = 28, // 28
    MINUTE_29 = 29, // 29
    MINUTE_30 = 30, // 30
    MINUTE_31 = 31, // 31
    MINUTE_32 = 32, // 32
    MINUTE_33 = 33, // 33
    MINUTE_34 = 34, // 34
    MINUTE_35 = 35, // 35
    MINUTE_36 = 36, // 36
    MINUTE_37 = 37, // 37
    MINUTE_38 = 38, // 38
    MINUTE_39 = 39, // 39
    MINUTE_40 = 40, // 40
    MINUTE_41 = 41, // 41
    MINUTE_42 = 42, // 42
    MINUTE_43 = 43, // 43
    MINUTE_44 = 44, // 44
    MINUTE_45 = 45, // 45
    MINUTE_46 = 46, // 46
    MINUTE_47 = 47, // 47
    MINUTE_48 = 48, // 48
    MINUTE_49 = 49, // 49
    MINUTE_50 = 50, // 50
    MINUTE_51 = 51, // 51
    MINUTE_52 = 52, // 52
    MINUTE_53 = 53, // 53
    MINUTE_54 = 54, // 54
    MINUTE_55 = 55, // 55
    MINUTE_56 = 56, // 56
    MINUTE_57 = 57, // 57
    MINUTE_58 = 58, // 58
    MINUTE_59 = 59  // 59
};
//+----------------------------------------------------------------------------+

enum ENUM_ONLINE_TIMEFRAMES
{
    TIMEFRAME_CURRENT = 0,      // current
    TIMEFRAME_M1 = PERIOD_M1,   // 1 minute
    TIMEFRAME_M5 = PERIOD_M5,   // 5 minutes
    TIMEFRAME_M15 = PERIOD_M15, // 15 minutes
    TIMEFRAME_M30 = PERIOD_M30, // 30 minutes
    TIMEFRAME_H1 = PERIOD_H1,   // 1 hour
    TIMEFRAME_H4 = PERIOD_H4,   // 4 hours
    TIMEFRAME_D1 = PERIOD_D1,   // 1 day
    TIMEFRAME_W1 = PERIOD_W1,   // 1 week
    TIMEFRAME_MN1 = PERIOD_MN1  // 1 month
};
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| MQL4Framework class                                                        |
//+----------------------------------------------------------------------------+
class MQL4Framework
{
    //--- [MQL4Framework] クラスの初期化処理を実行します。
    public: MQL4Framework()
    {
        // 共通クラスのインスタンスを生成。
        Common = new MQL4Common();
    
        // ログクラスのインスタンスを生成。
        Log = new MQL4Log();
    
        // 依存クラスのインスタンスを生成。
        Dependency = new MQL4Dependency();
    
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    }

    //--- [MQL4Framework] クラスの終了処理を実行します。
    public: ~MQL4Framework()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // 依存クラスのインスタンスを破棄。
        delete Dependency;
    
        // ログ出力クラスのインスタンスを破棄。
        delete Log;
    
        // 共通クラスのインスタンスを破棄。
        delete Common;
    }

    //--- [MQL4Framework] Expert initialization function
    public: int OnInit()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // 著作権を表示
        //ShowCopyright();
    
        // ターミナル情報をログ出力
        Log.Info(GetTerminalInfoLog());
    
        // アカウント情報をログ出力
        Log.Info(GetAccountInfoLog());
    
        // 通貨ペア情報をログ出力
        Log.Info(GetSymbolInfoLog(Symbol()));
    
        // プログラム情報をログ出力
        Log.Info(GetMQLInfoLog());
    
        // カスタムインジケーターを確認
        CheckCustomIndicator();
    
        // 初期化処理を実行
        int result = Init();
    
        // ログ出力
        if (result == INIT_SUCCEEDED) Log.Info("initialized");
    
        // 処理結果を返却
        return result;
    }

    //--- [MQL4Framework] Custom indicator iteration function
    public: int OnCalculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[], const long& volume[], const int& spread[])
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);

        // 共通クラスのティック前処理を実行
        Common.Before();
    
        // ログ出力クラスのティック前処理を実行
        Log.Before();

        // 著作権を表示
        //ShowCopyright();

        // 日付情報をログ出力
        Log.Debug(GetDateTimeLog());

        // レート情報をログ出力
        Log.Debug(GetRateLog());
    
        // ティック情報をログ出力
        Log.Debug(GetTickLog());
    
        // 関連するインジケーターの初期化処理を実行
        InitializeDependency();

        // インジケーター計算処理を実行
        int result = Calculate(rates_total, prev_calculated, time, open, high, low, close, tick_volume, volume, spread);
    
        // ログ出力クラスのティック後処理を実行
        Log.After();
    
        // 共通クラスのティック後処理を実行
        Common.After();
        
        // 処理結果を返却
        return result;
    }

    //--- [MQL4Framework] Script program start function
    public: void OnStart()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    }

    //--- [MQL4Framework] Expert deinitialization function
    public: void OnDeinit(const int reason, string obj_prefix = "")
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // 終了処理を実行
        Deinit();
    
        // コメント削除
        Comment("");
    
        // 全てのオブジェクトを削除
        DeleteAllObjects(obj_prefix);
    
        // ログ出力
        Log.Info("uninit reason " + IntegerToString(reason));
        Log.Info(GetUninitReasonText(reason));
    }

    //--- [MQL4Framework] Expert tick function
    void MQL4Framework :: OnTick()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // 共通クラスのティック前処理を実行
        Common.Before();
    
        // ログ出力クラスのティック前処理を実行
        Log.Before();

        // 著作権を表示
        //ShowCopyright();

        // 日付情報をログ出力
        Log.Debug(GetDateTimeLog());

        // レート情報をログ出力
        Log.Debug(GetRateLog());
    
        // ティック情報をログ出力
        Log.Debug(GetTickLog());
    
        // 関連するインジケーターの初期化処理を実行
        InitializeDependency();
    
        // インジケーターを全て処理
        for (int index = 0; index < Dependency.GetIndicatorsCount(); index++)
        {
            // インジケーター情報をログ出力
            Log.Debug(Dependency.GetIndicatorLog(index));
        }

        // ティック受信処理を実行
        Tick();
    
        // ログ出力クラスのティック後処理を実行
        Log.After();
    
        // 共通クラスのティック後処理を実行
        Common.After();
    }

    //--- [MQL4Framework] Timer function
    public: void OnTimer()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
        
        // タイマー処理を実行
        Timer();
    }

    //--- [MQL4Framework] ChartEvent function
    public: void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
        
        // イベント処理を実行
        ChartEvent(id, lparam, dparam, sparam);
    }

    //--- [MQL4Framework] 初期化処理を実行します。
    protected: virtual int Init()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
    
        return INIT_SUCCEEDED;
    }

    //--- [MQL4Framework] インジケーター計算処理を実行します。
    protected: virtual int Calculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[], const long& volume[], const int& spread[])
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);

        // オーバーライド
    
        return rates_total;
    }

    //--- [MQL4Framework] スクリプト処理を実行します。
    protected: virtual void Start()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);

        // オーバーライド
        
        return;
    }

    //--- [MQL4Framework] 終了処理を実行します。
    protected: virtual void Deinit()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
        
        return;
    }

    //--- [MQL4Framework] ティック受信処理を実行します。
    protected: virtual void Tick()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
        
        return;
    }

    //--- [MQL4Framework] タイマー処理を実行します。
    protected: virtual void Timer()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
        
        return;
    }

    //--- [MQL4Framework] イベント処理を実行します。
    protected: virtual void ChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
        
        return;
    }

    //--- [MQL4Framework] カスタムインジケーターを確認します。
    protected: virtual void CheckCustomIndicator()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
    
        return;
    }

    //--- [MQL4Framework] 関連するインジケーターの初期化処理を実行します。
    protected: virtual void InitializeDependency()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
        
        return;
    }
    
    //--- [MQL4Framework] 全てのオブジェクトを削除します。
    public: void DeleteAllObjects(string prefix = "")
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // 接頭辞を設定
        if (prefix == "") prefix = OBJNAME_PREFIX;
    
        // チャート上のオブジェクトを全て処理
        for (int index = 0; index < ObjectsTotal(); index++)
        {
            // プログラムにより作成したオブジェクト以外の場合は次へ
            if (StringFind(ObjectName(NULL, index), prefix) == EMPTY) continue;

            // オブジェクトを削除
            ObjectDelete(ObjectName(NULL, index));
    
            // オブジェクトの数が減るためデクリメント
            index--;
        }
    }

    //--- [MQL4Framework] アカウント情報のログ出力用文字列を取得します。
    private: string GetAccountInfoLog()
    {
        // ログ出力用文字列
        string message = "account: ";
        StringAdd(message, "balance=" + DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE)) + "; ");
        StringAdd(message, "company=" + AccountInfoString(ACCOUNT_COMPANY) + "; ");
        StringAdd(message, "credit=" + DoubleToString(AccountInfoDouble(ACCOUNT_CREDIT)) + "; ");
        StringAdd(message, "currency=" + AccountInfoString(ACCOUNT_CURRENCY) + "; ");
        StringAdd(message, "equity=" + DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY)) + "; ");
        StringAdd(message, "freemargin=" + DoubleToString(AccountInfoDouble(ACCOUNT_FREEMARGIN)) + "; ");
        StringAdd(message, "leverage=" + IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE)) + "; ");
        StringAdd(message, "limit_orders=" + IntegerToString(AccountInfoInteger(ACCOUNT_LIMIT_ORDERS)) + "; ");
        StringAdd(message, "login=" + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + "; ");
        StringAdd(message, "margin=" + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN)) + "; ");
        StringAdd(message, "margin_level=" + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)) + "; ");
        StringAdd(message, "margin_so_call=" + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL)) + "; ");
        StringAdd(message, "margin_so_mode=" + EnumToString((ENUM_ACCOUNT_STOPOUT_MODE) AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE)) + "; ");
        StringAdd(message, "margin_so_so=" + DoubleToString(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO)) + "; ");
        StringAdd(message, "name=" + AccountInfoString(ACCOUNT_NAME) + "; ");
        StringAdd(message, "profit=" + DoubleToString(AccountInfoDouble(ACCOUNT_PROFIT)) + "; ");
        StringAdd(message, "server=" + AccountInfoString(ACCOUNT_SERVER) + "; ");
        StringAdd(message, "trade_allowed=" + Common.BoolToString(AccountInfoInteger(ACCOUNT_TRADE_ALLOWED)) + "; ");
        StringAdd(message, "trade_expert=" + Common.BoolToString(AccountInfoInteger(ACCOUNT_TRADE_EXPERT)) + "; ");
        StringAdd(message, "trade_mode=" + EnumToString((ENUM_ACCOUNT_TRADE_MODE) AccountInfoInteger(ACCOUNT_TRADE_MODE)) + "; ");
    
        // ログ出力用文字列を返却
        return message;
    }

    //--- [MQL4Framework] 日付情報のログ出力用文字列を取得します。
    private: string GetDateTimeLog()
    {
        // チャート時刻を取得
        MqlDateTime time;
        TimeToStruct(Time[SHIFT_CURRENT], time);
    
        // ログ出力用文字列
        string message = "datetime: ";
        StringAdd(message, "year=" + IntegerToString(time.year) + "; ");
        StringAdd(message, "mon=" + IntegerToString(time.mon) + "; ");
        StringAdd(message, "day=" + IntegerToString(time.day) + "; ");
        StringAdd(message, "hour=" + IntegerToString(time.hour) + "; ");
        StringAdd(message, "min=" + IntegerToString(time.min) + "; ");
        StringAdd(message, "sec=" + IntegerToString(time.sec) + "; ");
        StringAdd(message, "day_of_week=" + EnumToString((ENUM_DAY_OF_WEEK) time.day_of_week) + "; ");
        StringAdd(message, "day_of_year=" + IntegerToString(time.day_of_year) + "; ");
    
        // ログ出力用文字列を返却
        return message;
    }

    //--- [MQL4Framework] プログラム情報のログ出力用文字列を取得します。
    private: string GetMQLInfoLog()
    {
        // ログ出力用文字列
        string message = "mql: ";
        StringAdd(message, "debug=" + Common.BoolToString(MQLInfoInteger(MQL_DEBUG)) + "; ");
        StringAdd(message, "dlls_allowed=" + Common.BoolToString(MQLInfoInteger(MQL_DLLS_ALLOWED)) + "; ");
        StringAdd(message, "frame_mode=" + Common.BoolToString(MQLInfoInteger(MQL_FRAME_MODE)) + "; ");
        StringAdd(message, "optimization=" + Common.BoolToString(MQLInfoInteger(MQL_OPTIMIZATION)) + "; ");
        StringAdd(message, "license_type=" + EnumToString((ENUM_LICENSE_TYPE) MQLInfoInteger(MQL_LICENSE_TYPE)) + "; ");
        StringAdd(message, "profiler=" + Common.BoolToString(MQLInfoInteger(MQL_PROFILER)) + "; ");
        StringAdd(message, "program_name=" + MQLInfoString(MQL_PROGRAM_NAME) + "; ");
        StringAdd(message, "program_path=" + MQLInfoString(MQL_PROGRAM_PATH) + "; ");
        StringAdd(message, "program_type=" + EnumToString((ENUM_PROGRAM_TYPE) MQLInfoInteger(MQL_PROGRAM_TYPE)) + "; ");
        StringAdd(message, "signals_allowed=" + Common.BoolToString(MQLInfoInteger(MQL_SIGNALS_ALLOWED)) + "; ");
        StringAdd(message, "tester=" + Common.BoolToString(MQLInfoInteger(MQL_TESTER)) + "; ");
        StringAdd(message, "trade_allowed=" + Common.BoolToString(MQLInfoInteger(MQL_TRADE_ALLOWED)) + "; ");
        StringAdd(message, "visual_mode=" + Common.BoolToString(MQLInfoInteger(MQL_VISUAL_MODE)) + "; ");
    
        // ログ出力用文字列を返却
        return message;
    }

    //--- [MQL4Framework] レート情報のログ出力用文字列を取得します。
    private: string GetRateLog()
    {
        // レート情報を取得
        MqlRates rates[];
        CopyRates(Symbol(), Period(), Time[SHIFT_CURRENT], Time[SHIFT_CURRENT], rates);
        
        if (ArraySize(rates) == 0) return "";
        
        // ログ出力用文字列
        string message = "rate: ";
        StringAdd(message, "time=" + TimeToString(rates[SHIFT_CURRENT].time, TIME_DATE | TIME_SECONDS) + "; ");
        StringAdd(message, "open=" + DoubleToString(rates[SHIFT_CURRENT].open, Digits) + "; ");
        StringAdd(message, "high=" + DoubleToString(rates[SHIFT_CURRENT].high, Digits) + "; ");
        StringAdd(message, "low=" + DoubleToString(rates[SHIFT_CURRENT].low, Digits) + "; ");
        StringAdd(message, "close=" + DoubleToString(rates[SHIFT_CURRENT].close, Digits) + "; ");
        StringAdd(message, "tick_volume=" + IntegerToString(rates[SHIFT_CURRENT].tick_volume) + "; ");
        //StringAdd(message, "spread=" + IntegerToString(rates[SHIFT_CURRENT].spread) + "; ");
        StringAdd(message, "spread=" + IntegerToString(SymbolInfoInteger(Symbol(), SYMBOL_SPREAD)) + "; "); // スプレッドが取得出来ないため通貨ペア情報から取得
        StringAdd(message, "real_volume=" + IntegerToString(rates[SHIFT_CURRENT].real_volume) + "; ");
    
        // ログ出力用文字列を返却
        return message;
    }
    
    //--- [MQL4Framework] 通貨ペア情報のログ出力用文字列を取得します。
    private: string GetSymbolInfoLog(string symbol)
    {
        // ログ出力用文字列
        string message = "symbol: ";
        StringAdd(message, "ask=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_ASK)) + "; ");
        StringAdd(message, "bid=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_BID)) + "; ");
        StringAdd(message, "currency_base=" + SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE) + "; ");
        StringAdd(message, "currency_margin=" + SymbolInfoString(symbol, SYMBOL_CURRENCY_MARGIN) + "; ");
        StringAdd(message, "currency_profit=" + SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT) + "; ");
        StringAdd(message, "description=" + SymbolInfoString(symbol, SYMBOL_DESCRIPTION) + "; ");
        StringAdd(message, "digits=" + IntegerToString(SymbolInfoInteger(symbol, SYMBOL_DIGITS)) + "; ");
        StringAdd(message, "expiration_time=" + TimeToString(SymbolInfoInteger(symbol, SYMBOL_EXPIRATION_TIME), TIME_DATE | TIME_SECONDS) + "; ");
        StringAdd(message, "margin_initial=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_MARGIN_INITIAL)) + "; ");
        StringAdd(message, "margin_maintenance=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_MARGIN_MAINTENANCE)) + "; ");
        StringAdd(message, "path=" + SymbolInfoString(symbol, SYMBOL_PATH) + "; ");
        StringAdd(message, "point=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_POINT)) + "; ");
        StringAdd(message, "select=" + Common.BoolToString(SymbolInfoInteger(symbol, SYMBOL_SELECT)) + "; ");
        StringAdd(message, "spread=" + IntegerToString(SymbolInfoInteger(symbol, SYMBOL_SPREAD)) + "; ");
        StringAdd(message, "spread_float=" + IntegerToString(SymbolInfoInteger(symbol, SYMBOL_SPREAD_FLOAT)) + "; ");
        StringAdd(message, "start_time=" + TimeToString(SymbolInfoInteger(symbol, SYMBOL_START_TIME), TIME_DATE | TIME_SECONDS) + "; ");
        StringAdd(message, "swap_long=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_SWAP_LONG)) + "; ");
        StringAdd(message, "swap_mode=" + IntegerToString(SymbolInfoInteger(symbol, SYMBOL_SWAP_MODE)) + "; ");
        StringAdd(message, "swap_rollover3days=" + EnumToString((ENUM_DAY_OF_WEEK) SymbolInfoInteger(symbol, SYMBOL_SWAP_ROLLOVER3DAYS)) + "; ");
        StringAdd(message, "swap_short=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_SWAP_SHORT)) + "; ");
        StringAdd(message, "time=" + TimeToString(SymbolInfoInteger(symbol, SYMBOL_TIME), TIME_DATE | TIME_SECONDS) + "; ");
        StringAdd(message, "trade_calc_mode=" + IntegerToString(SymbolInfoInteger(symbol, SYMBOL_TRADE_CALC_MODE)) + "; ");
        StringAdd(message, "trade_contract_size=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE)) + "; ");
        StringAdd(message, "trade_exemode=" + EnumToString((ENUM_SYMBOL_TRADE_EXECUTION) SymbolInfoInteger(symbol, SYMBOL_TRADE_EXEMODE)) + "; ");
        StringAdd(message, "trade_freeze_level=" + IntegerToString(SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL)) + "; ");
        StringAdd(message, "trade_mode=" + EnumToString((ENUM_SYMBOL_TRADE_MODE) SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE)) + "; ");
        StringAdd(message, "trade_stops_level=" + IntegerToString(SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL)) + "; ");
        StringAdd(message, "trade_tick_size=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE)) + "; ");
        StringAdd(message, "volume_max=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX)) + "; ");
        StringAdd(message, "volume_min=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN)) + "; ");
        StringAdd(message, "volume_step=" + DoubleToString(SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP)) + "; ");
    
        // ログ出力用文字列を返却
        return message;
    }

    //--- [MQL4Framework] ターミナル情報のログ出力用文字列を取得します。
    private: string GetTerminalInfoLog()
    {
        // ログ出力
        Log.Info("MetaTrader 4 build " + IntegerToString(TerminalInfoInteger(TERMINAL_BUILD)) + " (" + TerminalInfoString(TERMINAL_COMPANY) + ")");
    
        // ログ出力用文字列
        string message = "terminal: ";
        StringAdd(message, "build=" + IntegerToString(TerminalInfoInteger(TERMINAL_BUILD)) + "; ");
        StringAdd(message, "codepage=" + IntegerToString(TerminalInfoInteger(TERMINAL_CODEPAGE)) + "; ");
        StringAdd(message, "commondata_path=" + TerminalInfoString(TERMINAL_COMMONDATA_PATH) + "; ");
        StringAdd(message, "community_account=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_COMMUNITY_ACCOUNT)) + "; ");
        StringAdd(message, "community_balance=" + DoubleToString(TerminalInfoDouble(TERMINAL_COMMUNITY_BALANCE)) + "; ");
        StringAdd(message, "community_connection=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_COMMUNITY_CONNECTION)) + "; ");
        StringAdd(message, "company=" + TerminalInfoString(TERMINAL_COMPANY) + "; ");
        StringAdd(message, "connected=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_CONNECTED)) + "; ");
        StringAdd(message, "cpu_cores=" + IntegerToString(TerminalInfoInteger(TERMINAL_CPU_CORES)) + "; ");
        StringAdd(message, "data_path=" + TerminalInfoString(TERMINAL_DATA_PATH) + "; ");
        StringAdd(message, "disk_space=" + IntegerToString(TerminalInfoInteger(TERMINAL_DISK_SPACE)) + "; ");
        StringAdd(message, "dlls_allowed=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_DLLS_ALLOWED)) + "; ");
        StringAdd(message, "email_enabled=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_EMAIL_ENABLED)) + "; ");
        StringAdd(message, "ftp_enabled=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_FTP_ENABLED)) + "; ");
        StringAdd(message, "language=" + TerminalInfoString(TERMINAL_LANGUAGE) + "; ");
        StringAdd(message, "maxbars=" + IntegerToString(TerminalInfoInteger(TERMINAL_MAXBARS)) + "; ");
        StringAdd(message, "memory_available=" + IntegerToString(TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE)) + "; ");
        StringAdd(message, "memory_physical=" + IntegerToString(TerminalInfoInteger(TERMINAL_MEMORY_PHYSICAL)) + "; ");
        StringAdd(message, "memory_total=" + IntegerToString(TerminalInfoInteger(TERMINAL_MEMORY_TOTAL)) + "; ");
        StringAdd(message, "memory_used=" + IntegerToString(TerminalInfoInteger(TERMINAL_MEMORY_USED)) + "; ");
        StringAdd(message, "mqid=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_MQID)) + "; ");
        StringAdd(message, "name=" + TerminalInfoString(TERMINAL_NAME) + "; ");
        StringAdd(message, "notifications_enabled=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_NOTIFICATIONS_ENABLED)) + "; ");
        StringAdd(message, "path=" + TerminalInfoString(TERMINAL_PATH) + "; ");
        StringAdd(message, "trade_allowed=" + Common.BoolToString(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) + "; ");
    
        // ログ出力用文字列を返却
        return message;
    }

    //--- [MQL4Framework] ティック情報のログ出力用文字列を取得します。
    private: string MQL4Framework :: GetTickLog()
    {
        // レート情報を取得
        MqlTick tick;
        SymbolInfoTick(Symbol(), tick);
    
        // ログ出力用文字列
        string message = "tick: ";
        StringAdd(message, "time=" + TimeToString(tick.time, TIME_DATE | TIME_SECONDS) + "; ");
        StringAdd(message, "bid=" + DoubleToString(tick.bid, Digits) + "; ");
        StringAdd(message, "ask=" + DoubleToString(tick.ask, Digits) + "; ");
        StringAdd(message, "last=" + DoubleToString(tick.last, Digits) + "; ");
        StringAdd(message, "volume=" + IntegerToString(tick.volume) + "; ");
    
        // ログ出力用文字列を返却
        return message;
    }
    
    //--- [MQL4Framework] 終了コードの内容を取得します。
    private: string GetUninitReasonText(uint reason)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        if (reason == REASON_PROGRAM) return "Expert Advisor terminated its operation by calling the ExpertRemove() function";
        if (reason == REASON_REMOVE) return "Program has been deleted from the chart";
        if (reason == REASON_RECOMPILE) return "Program has been recompiled";
        if (reason == REASON_CHARTCHANGE) return "Symbol or chart period has been changed";
        if (reason == REASON_CHARTCLOSE) return "Chart has been closed";
        if (reason == REASON_PARAMETERS) return "Input parameters have been changed by a user";
        if (reason == REASON_ACCOUNT) return "Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings";
        if (reason == REASON_TEMPLATE) return "A new template has been applied";
        if (reason == REASON_INITFAILED) return "This value means that OnInit() handler has returned a nonzero value";
        if (reason == REASON_CLOSE) return "Terminal has been closed";
    
        // ログ出力
        Log.Warn("unknown reason [" + IntegerToString(reason) + "]");
    
        return "";
    }

    //--- [MQL4Framework] 著作権を表示します。
/*
    private: void ShowCopyright()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);

        // 著作権譲渡済みの場合は終了
        if (PROPERTY_COPYRIGHT == "") return;
    
        // 著作権文字色
        color c = COPYRIGHT_COLOR_BLACK;
    
        // 背景色が白の場合は文字色を変更
        if (ChartGetInteger(NULL, CHART_COLOR_BACKGROUND) == clrWhite) c = COPYRIGHT_COLOR_WHITE;

        // 著作権表示用ラベルを作成
        Common.CreateLabel(OBJNAME_COPYRIGHT, PROPERTY_COPYRIGHT, c, COPYRIGHT_SIZE, CORNER_LEFT_LOWER, 8, 5, COPYRIGHT_FONT, true);
    }
*/
};
//+----------------------------------------------------------------------------+


//--- Global Variables
MQL4Framework* Fw;
//+----------------------------------------------------------------------------+


//--- Declaration of Constants (#define)
#define OBJNAME_MESSAGE OBJNAME_PREFIX + "MESSAGE"
#define MESSAGE_COLOR clrRed
#define MESSAGE_FONT "Meiryo"
#define MESSAGE_SIZE 12
#define PI 3.14159265
//+----------------------------------------------------------------------------+


//--- Program Properties (#property)
#property strict
//+----------------------------------------------------------------------------+


//--- Conditional Compilation (#ifdef, #ifndef, #else, #endif)
#ifndef MQL4
#define OBJNAME_PREFIX ""
#endif 
//+----------------------------------------------------------------------------+


//--- Enumerations
enum ENUM_SHIFT
{
    SHIFT_CURRENT = 0,      // current bar
    SHIFT_PREVIOUS1 = 1,    // 1 previous bar
    SHIFT_PREVIOUS2 = 2,    // 2 previous bar
    SHIFT_PREVIOUS3 = 3,    // 3 previous bar
    SHIFT_PREVIOUS4 = 4,    // 4 previous bar
    SHIFT_PREVIOUS5 = 5,    // 5 previous bar
    SHIFT_PREVIOUS6 = 6     // 6 previous bar
};

enum ENUM_ON_OFF
{
    MODE_ON = 1,            // on
    MODE_OFF = 0            // off
};
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| MQL4Common class                                                           |
//+----------------------------------------------------------------------------+
class MQL4Common
{
    //--- [MQL4Common] 前回のASK価格
    public: double PreviousAsk;

    //--- [MQL4Common] 前回のBID価格
    public: double PreviousBid;

    //--- [MQL4Common] 前回の現在価格
    public: double PreviousClose;


    //--- [MQL4Common] クラスの初期化処理を実行します。
    public: MQL4Common()
    {
        // メンバ変数の初期化
        PreviousAsk = Ask;
        PreviousBid = Bid;
        if (ArraySize(Time) != NULL) PreviousTickTime = Time[SHIFT_CURRENT];
        if (ArraySize(Close) != NULL) PreviousClose = Close[SHIFT_CURRENT];
    }

    //--- [MQL4Common] クラスの終了処理を実行します。
    public: ~MQL4Common()
    {
    }

    //--- [MQL4Common] 指定した時間の範囲内かどうか判定します。
    public: bool IsIncludeTime(datetime target, uint begin_hour, uint begin_minute, uint end_hour, uint end_minute)
    {
        // 現在の時刻
        uint hour = TimeHour(target);
        uint minute = TimeMinute(target);
        
        string message = "time filter is ng (time=" + TimeToString(TimeCurrent(), TIME_MINUTES) + ")";
    
        // 開始時 < 終了時 の場合
        if (begin_hour < end_hour)
        {
            if (hour < begin_hour) return false;
            if (hour == begin_hour && minute < begin_minute) return false;
            if (hour == end_hour && end_minute <= minute) return false;
            if (end_hour < hour) return false;
        }
    
        // 終了時 < 開始時 の場合
        if (end_hour < begin_hour)
        {
            if (end_hour < hour && hour < begin_hour) return false;
            if (hour == begin_hour && minute < begin_minute) return false;
            if (hour == end_hour && end_minute <= minute) return false;
        }
    
        // 開始時 == 終了時 の場合
        if (begin_hour == end_hour)
        {
            // 開始分 < 終了分 の場合
            if (begin_minute < end_minute)
            {
                if (hour < begin_hour) return false;
                if (hour == begin_hour && minute < begin_minute) return false;
                if (hour == end_hour && end_minute <= minute) return false;
                if (end_hour < hour) return false;
            }
    
            // 終了分 < 開始分 の場合
            if (end_minute < begin_minute)
            {
                if (hour == begin_hour && hour == end_hour && end_minute <= minute && minute < begin_minute) return false;
            }
    
            // 開始分 == 終了分 の場合
            if (begin_minute == end_minute)
            {
                if (hour != begin_hour) return false;
                if (hour != end_hour) return false;
                if (minute != begin_minute) return false;
                if (minute != end_minute) return false;
            }
        }

        // 終了
        return true;
    }

    //--- [MQL4Common] 買い注文かどうかを判定します。
    public: bool IsBuyOrder(uint type)
    {
        if (type == ORDER_TYPE_SELL) return false;
        if (type == ORDER_TYPE_SELL_LIMIT) return false;
        if (type == ORDER_TYPE_SELL_STOP) return false;
        return true;
    }

    //--- [MQL4Common] 売り注文かどうかを判定します。
    public: bool IsSellOrder(uint type)
    {
        if (type == ORDER_TYPE_BUY) return false;
        if (type == ORDER_TYPE_BUY_LIMIT) return false;
        if (type == ORDER_TYPE_BUY_STOP) return false;
        return true;
    }

    //--- [MQL4Common] 始値のティックかどうかを判定します。
    public: bool IsOpenTick()
    {
        return PreviousTickTime != Time[SHIFT_CURRENT];
    }

    //--- [MQL4Common] ASK価格が指定した価格に触れたかどうかを判定します。
    public: bool IsTouchAsk(double price)
    {
        if (PreviousAsk < price && price <= Ask) return true;
        if (PreviousAsk > price && price >= Ask) return true;
        return false;
    }

    //--- [MQL4Common] BID価格が指定した価格に触れたかどうかを判定します。
    public: bool IsTouchBid(double price)
    {
        if (PreviousBid < NormalizeDouble(price, Digits) && NormalizeDouble(price, Digits) <= Bid) return true;
        if (PreviousBid > NormalizeDouble(price, Digits) && NormalizeDouble(price, Digits) >= Bid) return true;
        return false;
    }

    //--- [MQL4Common] 現在価格が指定した価格に触れたかどうかを判定します。
    public: bool IsTouchClose(double price)
    {
        if (PreviousClose < price && price <= Close[SHIFT_CURRENT]) return true;
        if (PreviousClose > price && price >= Close[SHIFT_CURRENT]) return true;
        return false;
    }

    //--- [MQL4Common] 成行注文かどうかを判定します。
    public: bool IsInstantOrder(uint type)
    {
        if (type == ORDER_TYPE_BUY) return true;
        if (type == ORDER_TYPE_SELL) return true;
        return false;
    }

    //--- [MQL4Common] 予約注文かどうかを判定します。
    public: bool IsPendingOrder(uint type)
    {
        if (type == ORDER_TYPE_BUY) return false;
        if (type == ORDER_TYPE_SELL) return false;
        return true;
    }

    //--- [MQL4Common] 注文数を取得します。
    public: uint OrdersTotal(string symbol, int magic = EMPTY, int type = EMPTY, string comment = NULL)
    {
        // 処理前の注文を一時保存
        uint tmp_ticket = OrderTicket();
    
        // 注文数
        uint count = 0;
    
        // 注文を全て処理
        for (int index = 0; index < (int) OrdersTotal(); index++)
        {
            // 注文を選択
            bool selected = OrderSelect(index, SELECT_BY_POS, MODE_TRADES);
    
            // 指定した注文以外の場合は次へ
            if (symbol != NULL && OrderSymbol() != symbol) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            if (comment != NULL && StringFind(OrderComment(), comment) == EMPTY) continue;
    
            // 注文数をインクリメント
            count++;
        }
    
        // 処理前の注文を再選択
        bool selected = OrderSelect(tmp_ticket, SELECT_BY_TICKET);
    
        // 注文数を返却
        return count;
    }

    //--- [MQL4Common] 注文数を取得します。
    public: uint OrdersHistoryTotal(string symbol, int magic = EMPTY, int type = EMPTY, string comment = NULL)
    {
        // 処理前の注文を一時保存
        uint tmp_ticket = OrderTicket();
    
        // 注文数
        uint count = 0;
    
        // 注文を全て処理
        for (int index = 0; index < OrdersHistoryTotal(); index++)
        {
            // 注文を選択
            bool selected = OrderSelect(index, SELECT_BY_POS, MODE_HISTORY);
    
            // 指定した注文以外の場合は次へ
            if (symbol != NULL && OrderSymbol() != symbol) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            if (comment != NULL && OrderComment() != comment) continue;
    
            // 注文数をインクリメント
            count++;
        }
    
        // 処理前の注文を再選択
        bool selected = OrderSelect(tmp_ticket, SELECT_BY_TICKET);
    
        // 注文数を返却
        return count;
    }

    //--- [MQL4Common] PipsをPointに変換します。
    public: int PipsToPoint(double pips)
    {
        return (int) NormalizeDouble(pips * 10, 0);
    }

    //--- [MQL4Common] PointをPipsに変換します。
    public: double PointToPips(int point)
    {
        return NormalizeDouble(point * 0.1, 1);
    }

    //--- [MQL4Common] PipsをPriceに変換します。
    public: double PipsToPrice(double pips, int digits = EMPTY)
    {
        if (digits == EMPTY) digits = Digits;
        return NormalizeDouble(pips * MathPow(0.1, digits - 1), digits);
    }

    //--- [MQL4Common] PriceをPipsに変換します。
    public: double PriceToPips(double price, int digits = EMPTY)
    {
        if (digits == EMPTY) digits = Digits;
        return NormalizeDouble(price * MathPow(10, digits - 1), 1);
    }

    //--- [MQL4Common] PointをPriceに変換します。
    public: double PointToPrice(int point, int digits = EMPTY)
    {
        if (digits == EMPTY) digits = Digits;
        return NormalizeDouble(point * MathPow(0.1, digits), digits);
    }

    //--- [MQL4Common] PriceをPointに変換します。
    public: int PriceToPoint(double price, int digits = EMPTY)
    {
        if (digits == EMPTY) digits = Digits;
        return (int) NormalizeDouble(price * MathPow(10, digits), 0);
    }

    //--- [MQL4Common] bool値を文字列に変換します。
    public: string BoolToString(bool b)
    {
        if (b) return "true";
        if (!b) return "false";
        return "";
    }

    //--- [MQL4Common] 取引種別を文字列に変換します。
    public: string OrderTypeToString(uint type)
    {
        if (type == ORDER_TYPE_BUY) return "buy";
        if (type == ORDER_TYPE_BUY_LIMIT) return "buy limit";
        if (type == ORDER_TYPE_BUY_STOP) return "buy stop";
        if (type == ORDER_TYPE_SELL) return "sell";
        if (type == ORDER_TYPE_SELL_LIMIT) return "sell limit";
        if (type == ORDER_TYPE_SELL_STOP) return "sell stop";
        return "";
    }

    //--- [MQL4Common] 取引種別を文字列に変換します。
    public: string OrderTypeToString(ENUM_ORDER_TYPE type)
    {
        return OrderTypeToString((uint) type);
    }

    //--- [MQL4Common] 取引種別をinstantまたはpendingの文字列に変換します。
    public: string OrderTypeToInstantOrPendingString(ENUM_ORDER_TYPE type)
    {
        if (type == ORDER_TYPE_BUY) return "instant";
        if (type == ORDER_TYPE_BUY_LIMIT) return "pending";
        if (type == ORDER_TYPE_BUY_STOP) return "pending";
        if (type == ORDER_TYPE_SELL) return "instant";
        if (type == ORDER_TYPE_SELL_LIMIT) return "pending";
        if (type == ORDER_TYPE_SELL_STOP) return "pending";
        return "";
    }

    //--- [MQL4Common] 時間足を文字列に変換します。
    public: string TimeframeToString(uint timeframe)
    {
        if (timeframe == PERIOD_M1) return "M1";
        if (timeframe == PERIOD_M5) return "M5";
        if (timeframe == PERIOD_M15) return "M15";
        if (timeframe == PERIOD_M30) return "M30";
        if (timeframe == PERIOD_H1) return "H1";
        if (timeframe == PERIOD_H4) return "H4";
        if (timeframe == PERIOD_D1) return "D1";
        if (timeframe == PERIOD_W1) return "W1";
        if (timeframe == PERIOD_MN1) return "MN1";
        return "M" + IntegerToString(timeframe);
    }

    //--- [MQL4Common] 前処理を実行します。
    public: void Before()
    {
    }

    //--- [MQL4Common] 後処理を実行します。
    public: void After()
    {
        // メンバ変数を更新
        PreviousTickTime = Time[SHIFT_CURRENT];
        PreviousAsk = Ask;
        PreviousBid = Bid;
        PreviousClose = Close[SHIFT_CURRENT];
    }
    
    public: void CreateButton(string name, string text, ENUM_BASE_CORNER corner, int x, int y, int width, int height, color fg_color = clrNONE, color bg_color = clrNONE, string font = "Arial", string window_name = "")
    {
        fg_color = fg_color == clrNONE ? (color) ChartGetInteger(NULL, CHART_COLOR_FOREGROUND) : fg_color;
        bg_color = bg_color == clrNONE ? (color) ChartGetInteger(NULL, CHART_COLOR_BACKGROUND) : bg_color;
        ObjectCreate(NULL, name, OBJ_BUTTON, window_name == "" ? NULL : (window_name == "0" ? NULL : WindowFind(window_name)), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BGCOLOR, bg_color);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, fg_color);
        ObjectSetInteger(NULL, name, OBJPROP_CORNER, corner);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(NULL, name, OBJPROP_XSIZE, width);
        ObjectSetInteger(NULL, name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(NULL, name, OBJPROP_YSIZE, height);
        ObjectSetInteger(NULL, name, OBJPROP_FONTSIZE, 12);
        ObjectSetString(NULL, name, OBJPROP_TEXT, text);
        ObjectSetString(NULL, name, OBJPROP_FONT, font);
        
        //if (corner == CORNER_LEFT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
        //if (corner == CORNER_LEFT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
        //if (corner == CORNER_RIGHT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
        //if (corner == CORNER_RIGHT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_LOWER);
        ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
    }
    
    public: void CreateEdit(string name, string text, ENUM_BASE_CORNER corner, int x, int y, int width, int height, ENUM_ALIGN_MODE align = ALIGN_LEFT)
    {
        ObjectCreate(NULL, name, OBJ_EDIT, NULL, NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_ALIGN, align);
        ObjectSetInteger(NULL, name, OBJPROP_BGCOLOR, clrWhite);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, clrBlack);
        ObjectSetInteger(NULL, name, OBJPROP_CORNER, corner);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(NULL, name, OBJPROP_XSIZE, width);
        ObjectSetInteger(NULL, name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(NULL, name, OBJPROP_YSIZE, height);
        ObjectSetInteger(NULL, name, OBJPROP_FONTSIZE, 10);
        ObjectSetString(NULL, name, OBJPROP_TEXT, text);
        ObjectSetString(NULL, name, OBJPROP_FONT, "Arial");
    }
    
    //--- [MQL4Common] 水平線を作成します。
    public: void CreateHLine(string name, double price, color c, int width = 1, ENUM_LINE_STYLE style = STYLE_SOLID, bool chart_window = true, bool back = false, string dscr = "")
    {
        ObjectCreate(NULL, name, OBJ_HLINE, chart_window ? NULL : WindowOnDropped(), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(NULL, name, OBJPROP_STYLE, style);
        ObjectSetInteger(NULL, name, OBJPROP_WIDTH, width);
        ObjectSetDouble(NULL, name, OBJPROP_PRICE, 0, price);
        ObjectSetString(NULL, name, OBJPROP_TEXT, dscr);
    }
    
    //--- [MQL4Common] 縦線を作成します。
    public: void CreateVLine(string name, datetime time, color c, int width = 1, ENUM_LINE_STYLE style = STYLE_SOLID, bool back = false, bool chart_window = true)
    {
        ObjectCreate(NULL, name, OBJ_VLINE, 0, NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        //ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(NULL, name, OBJPROP_STYLE, style);
        ObjectSetInteger(NULL, name, OBJPROP_TIME, 0, time);
        ObjectSetInteger(NULL, name, OBJPROP_WIDTH, width);
    }

    //--- [MQL4Common] トレンドラインを作成します。
    public: void CreateTrendLine(string name, datetime time1, double price1, datetime time2, double price2, bool ray, color c, int width = 1, ENUM_LINE_STYLE style = STYLE_SOLID, bool back = false, bool chart_window = true, bool selectable = true)
    {
        ObjectCreate(NULL, name, OBJ_TREND, chart_window ? NULL : WindowOnDropped(), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_RAY, ray);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, selectable);
        ObjectSetInteger(NULL, name, OBJPROP_STYLE, style);
        ObjectSetInteger(NULL, name, OBJPROP_TIME, 0, time1);
        ObjectSetInteger(NULL, name, OBJPROP_TIME, 1, time2);
        ObjectSetInteger(NULL, name, OBJPROP_WIDTH, width);
        ObjectSetDouble(NULL, name, OBJPROP_PRICE, 0, price1);
        ObjectSetDouble(NULL, name, OBJPROP_PRICE, 1, price2);
    }

    //--- [MQL4Common] 矢印オブジェクトを作成します。
    public: void CreateArrow(string name, uint code, color c, int size, datetime time, double price, ENUM_ARROW_ANCHOR anchor = ANCHOR_TOP, bool chart_window = true, bool is_back = false)
    {
    	ObjectCreate(NULL, name, OBJ_ARROW, chart_window ? NULL : WindowOnDropped(), NULL, NULL);
    	ObjectSetInteger(NULL, name, OBJPROP_ARROWCODE, code);
    	ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, anchor);
    	ObjectSetInteger(NULL, name, OBJPROP_BACK, is_back);
    	ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
    	ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
    	ObjectSetInteger(NULL, name, OBJPROP_SELECTED, false);
    	ObjectSetInteger(NULL, name, OBJPROP_TIME, 0, time);
    	ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
    	ObjectSetInteger(NULL, name, OBJPROP_WIDTH, size);
    	ObjectSetDouble(NULL, name, OBJPROP_PRICE, 0, price);
    }

    //--- [MQL4Common] ラベルオブジェクトを作成します。
    public: void CreateLabel(string name, string text, color c, uint size, ENUM_BASE_CORNER corner, uint x, uint y, string font, bool back = false, string window_name = "")
    {
        // ラベルオブジェクトを作成
        ObjectCreate(NULL, name, OBJ_LABEL, window_name == "" ? NULL : (window_name == "0" ? NULL : WindowFind(window_name)), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_CORNER, corner);
        ObjectSetInteger(NULL, name, OBJPROP_FONTSIZE, size);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(NULL, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(NULL, name, OBJPROP_YDISTANCE, y);
        ObjectSetString(NULL, name, OBJPROP_FONT, font);
        ObjectSetString(NULL, name, OBJPROP_TEXT, text);
    
        // 表示位置によりアンカーを設定
        if (corner == CORNER_LEFT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
        if (corner == CORNER_LEFT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
        if (corner == CORNER_RIGHT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
        if (corner == CORNER_RIGHT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_LOWER);
    }

    //--- [MQL4Common] テキストオブジェクトを作成します。
    public: void CreateText(string name, string text, color c, uint size, datetime time, double price, ENUM_ANCHOR_POINT anchor, string font, bool back = false, string window_name = "")
    {
        // ラベルオブジェクトを作成
        ObjectCreate(NULL, name, OBJ_TEXT, window_name == "" ? NULL : WindowFind(window_name), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, anchor);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_FONTSIZE, size);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
        ObjectSetString(NULL, name, OBJPROP_FONT, font);
        ObjectSetString(NULL, name, OBJPROP_TEXT, text);
        ObjectSetInteger(NULL, name, OBJPROP_TIME, 0, time);
        ObjectSetDouble(NULL, name, OBJPROP_PRICE, 0, price);
    }

    //--- [MQL4Common] レクタングルオブジェクトを作成します。
    public: void CreateRectangle(string name, datetime time1, double price1, datetime time2, double price2, color c, bool back = false)
    {
        // レクタングルオブジェクトを作成
        ObjectCreate(NULL, name, OBJ_RECTANGLE, WindowOnDropped(), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(NULL, name, OBJPROP_TIME, 0, time1);
        ObjectSetInteger(NULL, name, OBJPROP_TIME, 1, time2);
        ObjectSetDouble(NULL, name, OBJPROP_PRICE, 0, price1);
        ObjectSetDouble(NULL, name, OBJPROP_PRICE, 1, price2);
    }

    //--- [MQL4Common] レクタングルラベルオブジェクトを作成します。
    public: void CreateRectangleLabel(string name, int x, int y, int width, int height, color c, bool back = false)
    {
        // レクタングルオブジェクトを作成
        ObjectCreate(NULL, name, OBJ_RECTANGLE_LABEL, WindowOnDropped(), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_BGCOLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(NULL, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(NULL, name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(NULL, name, OBJPROP_XSIZE, width);
        ObjectSetInteger(NULL, name, OBJPROP_YSIZE, height);
        ObjectSetInteger(NULL, name, OBJPROP_BORDER_TYPE, BORDER_RAISED);
    }

    //--- [MQL4Common] メッセージを表示します。
    public: void ShowMessage(string message, bool back = true, uint size = MESSAGE_SIZE, string font = MESSAGE_FONT)
    {
        // メッセージを表示
        Common.CreateLabel(OBJNAME_MESSAGE, message, MESSAGE_COLOR, size, CORNER_LEFT_LOWER, 13, 8, font, back);
        Print(message);
    }

    //--- [MQL4Common] メッセージを削除します。
    public: void HideMessage()
    {
        // メッセージを非表示
        ObjectDelete(OBJNAME_MESSAGE);
    }
    
    //--- [MQL4Common] 角度を取得します
    public: double Angle(double value1, double value2, uint bars = 1)
    {
        if (bars == 0) return 0.0;
        return (MathArctan((value2 - value1) / (Point * 10 * bars)) * 180 / PI);
    }
    
    public: double Cross(double data1_from, double data1_to, double data2_from, double data2_to)
    {
        double data1_a = data1_to - data1_from;
        double data2_a = data2_to - data2_from;

        if (data1_a == data2_a) return EMPTY;

        double data1_b = data1_from - data1_a;
        double data2_b = data2_from - data2_a;
        
        double x = (data2_b - data1_b) / (data1_a - data2_a);
        double y = (data1_a * x) + data1_b;
        
        return y;
    }
    
    //--- [MQL4Common] スクリーンショットを採取します
    public: void ChartScreenShot(string name = "")
    {
        string timestamp = TimeToString(Time[0]);
        StringReplace(timestamp, ".", "");
        StringReplace(timestamp, ":", "");
        StringReplace(timestamp, " ", "");

        string filename = WindowExpertName() + "/" + Symbol() + IntegerToString(Period()) + "_" + timestamp + (name != "" ? "_" + name : "") + ".png";
        
        if (FileIsExist(filename)) FileDelete(filename);
        
        ChartScreenShot(NULL, filename, 1280, 720);
        PlaySound("tick.wav");
    }
    
    //--- [MQL4Common] 全てのポジションを決済します
    public: void OrdersCloseAll(string symbol = NULL, int magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY, string comment = NULL)
    {
        for (int count = 1; count <= 10; count++)
        {
            if (Common.OrdersTotal(symbol, magic, type, comment) == 0) break;

            for (int order = (int) OrdersTotal() - 1; 0 <= order; order--)
            {
                bool selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
                if (symbol != NULL && OrderSymbol() != symbol) continue;
                if (magic != EMPTY && OrderMagicNumber() != magic) continue;
                if (type != EMPTY && OrderType() != type) continue;
                if (comment != NULL && StringFind(OrderComment(), comment) == EMPTY) continue;
    
                if (OrderType() == ORDER_TYPE_BUY || OrderType() == ORDER_TYPE_SELL)
                {
                    RefreshRates();
                    bool closed = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), Common.PipsToPoint(100), OrderType() == ORDER_TYPE_BUY ? clrBlue : clrRed);
                    
                    if (closed)
                    {
                        bool b = OrderSelect(OrderTicket(), SELECT_BY_TICKET);
                    }
                }
                
                Sleep(1000);
            }
        }
    }
    
    //--- [MQL4Common] 全てのポジションを削除します
    public: void OrdersDeleteAll(string symbol = NULL, int magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY, string comment = NULL)
    {
        for (int order = (int) OrdersTotal() - 1; 0 <= order; order--)
        {
            bool selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (symbol != NULL && OrderSymbol() != symbol) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            if (comment != NULL && OrderComment() != comment) continue;

            if (OrderType() != ORDER_TYPE_BUY && OrderType() != ORDER_TYPE_SELL)
            {
                RefreshRates();
                bool deleted = OrderDelete(OrderTicket());
            }
        }
    }

    //--- [MQL4Common] 全てのポジションの合計ロット数を取得します
    public: double OrdersAllLots(string symbol = NULL, long magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY, string comment = NULL)
    {
        int ticket = OrderTicket();
    
        bool selected = false;
    
        double total_lots = NULL;
        
        for (int order = 0; order < (int) OrdersTotal(); order++)
        {
            selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (symbol != NULL && OrderSymbol() != symbol) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            if (comment != NULL && StringFind(OrderComment(), comment) == EMPTY) continue;
            
            total_lots = NormalizeDouble(total_lots + OrderLots(), 3);
        }
        
        selected = OrderSelect(ticket, SELECT_BY_TICKET);
        
        return total_lots;
    }

    //--- [MQL4Common] 全てのポジションの合計損益を取得します
    public: double OrdersAllProfit(string symbol = NULL, long magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY, string comment = NULL)
    {
        int ticket = OrderTicket();
    
        bool selected = false;
    
        double profit = NULL;
        
        for (int order = 0; order < (int) OrdersTotal(); order++)
        {
            selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (symbol != NULL && OrderSymbol() != symbol) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            if (comment != NULL && StringFind(OrderComment(), comment) == EMPTY) continue;
            
            profit = profit + OrderProfit() + OrderSwap() + OrderCommission();
        }
        
        selected = OrderSelect(ticket, SELECT_BY_TICKET);
        
        return profit;
    }

    //--- [MQL4Common] 全てのポジションの合計損益Pipsを取得します
    public: double OrdersAllProfitPips(string symbol, int magic, ENUM_ORDER_TYPE type = EMPTY, string comment = NULL)
    {
        int ticket = OrderTicket();
    
        bool selected = false;
    
        double pips = NULL;
        
        for (int order = 0; order < (int) OrdersTotal(); order++)
        {
            selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != symbol) continue;
            if (OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            if (comment != NULL && StringFind(OrderComment(), comment) == EMPTY) continue;
            
            if (OrderType() == ORDER_TYPE_BUY) pips = NormalizeDouble(pips + Common.PriceToPips(OrderClosePrice() - OrderOpenPrice()), 1);
            if (OrderType() == ORDER_TYPE_SELL) pips = NormalizeDouble(pips + Common.PriceToPips(OrderOpenPrice() - OrderClosePrice()), 1);
        }

        selected = OrderSelect(ticket, SELECT_BY_TICKET);
        
        return pips;
    }

    //--- [MQL4Common] ローソク足の幅を取得します
    public: uint ChartGetCandlestikWidth()
    {
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 0) return 1;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 1) return 1;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 2) return 2;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 3) return 3;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 4) return 6;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 5) return 13;
        return 0;
    }

    //--- [MQL4Common] ローソク足の幅を取得します
    public: uint ChartGetCandlestikFillWidth()
    {
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 0) return 1;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 1) return 2;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 2) return 4;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 3) return 8;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 4) return 16;
        if (ChartGetInteger(ChartID(), CHART_SCALE) == 5) return 32;
        return 0;
    }
    
    /* 呼び出し元で以下のイベントを記載すること
    void OnChartEvent(const int id, const long& lparam, const double& dparam, const string& sparam)
    {
        if (id != CHARTEVENT_CHART_CHANGE) return;
        SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, Common.ChartGetCandlestikWidth(), ColorBull);
        SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, Common.ChartGetCandlestikWidth(), ColorBear);
        ChartRedraw(ChartID());
    }
    */

    public: double NormalizeDoubleMorePrecision(double value, int digits)
    {
        value = value * MathPow(10, digits + 1);
        value = MathFloor(value);
        value = value * MathPow(0.1, digits + 1);
        return NormalizeDouble(value, digits);
    }
    
    public: double OrderLotsByStopLoss(double lots, double risk, double open_price, double stoploss_price)
    {
        if (lots != 0.0) return lots;
        return OrderLotsByStopLoss(risk, open_price, stoploss_price);
    }
    
    public: double OrderLotsByStopLoss(double risk, double open_price, double stoploss_price)
    {
        double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
        
        if (MarketInfo(Symbol(), MODE_DIGITS) == 3 || MarketInfo(Symbol(), MODE_DIGITS) == 5)
        {
            tickValue *= 10.0;
        }
        
        double sl_pips = 0.0;
        if (open_price > stoploss_price) sl_pips = Common.PriceToPips(open_price - stoploss_price); // buy
        if (open_price < stoploss_price) sl_pips = Common.PriceToPips(stoploss_price - open_price); // sell

        double base = AccountBalance();
        double riskAmount = base * (risk / 100.0);
        double lotSize = riskAmount / (sl_pips * tickValue);
        double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);

        int digits = 0;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.1) digits = 1;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.01) digits = 2;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.001) digits = 3;
    
        lotSize = TruncationDouble(MathFloor(lotSize / lotStep) * lotStep, digits);

        double margin = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    
        if (margin > 0.0)
        {
            double accountMax = AccountBalance() / margin;
            accountMax = MathFloor(accountMax / lotStep) * lotStep;
    
            if (lotSize > accountMax)
            {
                lotSize = TruncationDouble(accountMax, digits);
            }
        }
        
        // 最大ロット数、最小ロット数対応
        double minLots = MarketInfo(Symbol(), MODE_MINLOT);
        double maxLots = MarketInfo(Symbol(), MODE_MAXLOT);
        
        if (lotSize < minLots)
        {
            lotSize = minLots;
        }
        else if (lotSize > maxLots)
        {
            lotSize = maxLots;
        }
    
        return lotSize;
    }
    
    public: double OrderLotsByStopLossPips(double base, double risk, double sl_pips)
    {
        double riskAmount = base * (risk / 100.0);
        return OrderLotsByStopLossPips(riskAmount, sl_pips);
    }
    
    public: double OrderLotsByStopLossPips(double riskAmount, double sl_pips)
    {
        double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
        
        if (MarketInfo(Symbol(), MODE_DIGITS) == 3 || MarketInfo(Symbol(), MODE_DIGITS) == 5)
        {
            tickValue *= 10.0;
        }
        
        double lotSize = riskAmount / (sl_pips * tickValue);
        double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);

        int digits = 0;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.1) digits = 1;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.01) digits = 2;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.001) digits = 3;
    
        lotSize = TruncationDouble(MathFloor(lotSize / lotStep) * lotStep, digits);

        // 最大ロット数、最小ロット数対応
        double minLots = MarketInfo(Symbol(), MODE_MINLOT);
        double maxLots = MarketInfo(Symbol(), MODE_MAXLOT);
        
        if (lotSize < minLots)
        {
            lotSize = minLots;
        }
        else if (lotSize > maxLots)
        {
            lotSize = maxLots;
        }
    
        return lotSize;
    }
    
    public: double TruncationDouble(double value, int digits)
    {
        return RoundDownDouble(value, digits);
    }
    
    public: double RoundUpDouble(double value, int digits)
    {
        double a = TruncationDouble(value, digits);
        if (a == value) return value;
        return NormalizeDouble(a + MathPow(0.1, digits), digits);
    }

    public: double RoundDownDouble(double value, int digits)
    {
        int a = (int) (value * MathPow(10, digits));
        return NormalizeDouble(a * MathPow(0.1, digits), digits);
    }
    
    public: string MoneyToString(double amount, int digits = 0)
    {
        string tmp = DoubleToString(amount, digits);
        
        int length = StringLen(tmp);
        
        int count = 0;
        
        string result = "";
        
        // +
        if (amount >= 0)
        {
            for (int index = StringLen(tmp) - 1; 0 <= index; index--)
            {
                count++;
        
                result = StringSubstr(tmp, index, 1) + result;
        
                if (StringSubstr(tmp, index, 1) == ".")
                {
                    continue;
                }
                
                if (count % 3 != 0) continue;
                if (index == 0) continue;
                
                result = "," + result;
            }
        }
        // -
        else
        {
            for (int index = StringLen(tmp) - 1; 1 <= index; index--)
            {
                count++;
        
                result = StringSubstr(tmp, index, 1) + result;

                if (StringSubstr(tmp, index, 1) == ".")
                {
                    continue;
                }

                if (count % 3 != 0) continue;
                if (index == 1) continue;
                
                result = "," + result;
            }
            
            result = "-" + result;
        }
        
        return result;
    }
    
    // 指定した値が配列に含まれているかどうか
    public: bool ArrayIsInclude(string& array[], string value)
    {
        for (int index = 0; index < ArraySize(array); index++)
        {
            if (value != array[index]) continue;
            
            // 指定した値に該当
            return true;
        }
        
        // 指定した値が見つからない
        return false;
    }
    
    // 指定した値が配列に含まれているかどうか
    public: bool ArrayIsInclude(uint& array[], uint value)
    {
        for (int index = 0; index < ArraySize(array); index++)
        {
            if (value != array[index]) continue;
            
            // 指定した値に該当
            return true;
        }
        
        // 指定した値が見つからない
        return false;
    }
    
    // 指定した値が配列に含まれているかどうか
    public: bool ArrayIsInclude(long& array[], long value)
    {
        for (int index = 0; index < ArraySize(array); index++)
        {
            if (value != array[index]) continue;
            
            // 指定した値に該当
            return true;
        }
        
        // 指定した値が見つからない
        return false;
    }
    
    // 指定した値が配列に含まれているかどうか
    public: bool ArrayIsInclude(double& array[], double value)
    {
        for (int index = 0; index < ArraySize(array); index++)
        {
            if (value != array[index]) continue;
            
            // 指定した値に該当
            return true;
        }
        
        // 指定した値が見つからない
        return false;
    }
    
    
    // 指定した値が配列に含まれているかどうか
    public: int ArrayIsIncludeCount(double& array[], double value)
    {
        int count = 0;
    
        for (int index = 0; index < ArraySize(array); index++)
        {
            if (value != array[index]) continue;
            
            // 指定した値に該当
            count++;
        }
        
        return count;
    }
    
    public: double ExcelSlope(double& array_y[], double& array_x[])
    {
        double average_x = ExcelAverage(array_x);
        double average_y = ExcelAverage(array_y);

        double stdev_x = ExcelStdEV(array_x);
        double stdev_y = ExcelStdEV(array_y);

        return ExcelCorrel(array_x, array_y) * stdev_y / stdev_x;
    }
    
    public: double ExcelAverage(double& array[])
    {
        double total = NULL;
    
        for (int index = 0; index < ArraySize(array); index++)
        {
            total = total + array[index];
        }
        
        return total / ArraySize(array);
    }

    public: double ExcelStdEV(double& array[])
    {
        double average = ExcelAverage(array);
        
        double total = NULL;
        
        for (int index = 0; index < ArraySize(array); index++)
        {
            total = total + MathPow(array[index] - average, 2);
        }
        
        return MathSqrt(total / (ArraySize(array) - 1));
    }
    
    public: double ExcelCorrel(double& array_x[], double& array_y[])
    {
        double average_x = ExcelAverage(array_x);
        double average_y = ExcelAverage(array_y);

        double array1[];
        for (int index = 0; index < ArraySize(array_x); index++)
        {
            ArrayResize(array1, ArraySize(array1) + 1);
            array1[ArraySize(array1) - 1] = array_x[index] - average_x;
        }

        double array2[];
        for (int index = 0; index < ArraySize(array_y); index++)
        {
            ArrayResize(array2, ArraySize(array2) + 1);
            array2[ArraySize(array2) - 1] = array_y[index] - average_y;
        }

        if (MathSqrt(ExcelSumProduct(array2, array2)) == 0) return 0;

        return ExcelSumProduct(array1, array2) / MathSqrt(ExcelSumProduct(array1, array1)) / MathSqrt(ExcelSumProduct(array2, array2));
    }
    
    public: double ExcelSumProduct(double& array1[], double& array2[])
    {
        double result = NULL;
    
        for (int index = 0; index < ArraySize(array1); index++)
        {
            result = result + (array1[index] * array2[index]);
        }
        
        return result;
    }
    
    public: double TimeToSerialTime(datetime time)
    {
        return ((double) time / 60 / 60 / 24) + 25569;
    }
    
    public: double TimeToSerialTime2(datetime time)
    {
        return ((double) time / 60 / 60 / 24);
    }
    
    public: int LotsDigits()
    {
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.1) return 1;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.01) return 2;
        if (SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN) == 0.001) return 3;
        return 0;
    }

    public: double LastOrderOpenPrice(string symbol = NULL, int magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY)
    {
        int ticket = OrderTicket();
    
        double open_price = NULL;
    
        for (int order = (int) OrdersTotal() - 1; 0 <= order; order--)
        {
            bool selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (symbol != NULL && OrderSymbol() != Symbol()) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            
            open_price = OrderOpenPrice();
            
            break;
        }
        
        bool selected = OrderSelect(ticket, SELECT_BY_TICKET);
        
        return open_price;
    }

    public: datetime LastOrderOpenTime(string symbol = NULL, int magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY)
    {
        int ticket = OrderTicket();
    
        datetime open_time = NULL;
    
        for (int order = (int) OrdersTotal() - 1; 0 <= order; order--)
        {
            bool selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (symbol != NULL && OrderSymbol() != Symbol()) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            
            open_time = OrderOpenTime();
            
            break;
        }
        
        bool selected = OrderSelect(ticket, SELECT_BY_TICKET);
        
        return open_time;
    }

    public: double LastOrderLots(string symbol = NULL, int magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY)
    {
        int ticket = OrderTicket();
    
        double order_lots = NULL;
    
        for (int order = (int) OrdersTotal() - 1; 0 <= order; order--)
        {
            bool selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (symbol != NULL && OrderSymbol() != Symbol()) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            
            order_lots = OrderLots();
            
            break;
        }
        
        bool selected = OrderSelect(ticket, SELECT_BY_TICKET);
        
        return order_lots;
    }

    public: int LastOrderTicket(string symbol = NULL, int magic = EMPTY, ENUM_ORDER_TYPE type = EMPTY)
    {
        int ticket = OrderTicket();
    
        int order_ticket = NULL;
    
        for (int order = (int) OrdersTotal() - 1; 0 <= order; order--)
        {
            bool selected = OrderSelect(order, SELECT_BY_POS, MODE_TRADES);
            if (symbol != NULL && OrderSymbol() != Symbol()) continue;
            if (magic != EMPTY && OrderMagicNumber() != magic) continue;
            if (type != EMPTY && OrderType() != type) continue;
            
            order_ticket = OrderTicket();
            
            break;
        }
        
        bool selected = OrderSelect(ticket, SELECT_BY_TICKET);
        
        return order_ticket;
    }
    
    public: double GetDynamicLots(double base, double risk)
    {
        double a = NormalizeDouble(base * (risk * 0.01), 2);
        
        double b = NULL;
        
        if (AccountCurrency() == "JPY")
        {
            b = NormalizeDouble(a * 0.00001, 8);
        }
        else
        {
            b = NormalizeDouble(a * 0.001, 8);
        }
        
        return RoundDownDouble(b, LotsDigits());
    }
};
//+----------------------------------------------------------------------------+


//--- Global Variables
MQL4Common* Common;
datetime PreviousTickTime;
//+----------------------------------------------------------------------------+


//--- Declaration of Constants (#define)
#define LEVEL_FALAL 5
#define LEVEL_ERROR 4
#define LEVEL_WARN 3
#define LEVEL_INFO 2
#define LEVEL_DEBUG 1
#define LEVEL_TRACE 0
#define LEVEL_NONE -1
//+----------------------------------------------------------------------------+


//--- Program Properties (#property)
#property strict
//+----------------------------------------------------------------------------+


//--- Conditional Compilation (#ifdef, #ifndef, #else, #endif)
#ifndef MQL4
#define OUTPUT_CONSOLE LEVEL_INFO
#define OUTPUT_FILE LEVEL_DEBUG
#define OUTPUT_TESTING false
#include "MQL4Common.mqh"
#endif 
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| MQL4Log class                                                              |
//+----------------------------------------------------------------------------+
class MQL4Log
{
    //--- [MQL4Log] ログファイルハンドル
    private: int LogFileHandle;

    //--- [MQL4Log] クラスの初期化処理を実行します。
    public: MQL4Log()
    {
        // メンバ変数の初期化
        LogFileHandle = EMPTY;
    
        // 前月以前のログファイルを削除
        DeleteLogFile();
    
        // ログファイルを開く
        OpenLogFile();
    }

    //--- [MQL4Log] クラスの終了処理を実行します。
    public: ~MQL4Log()
    {
        // ログファイルを閉じる
        CloseLogFile();
    }

    //--- [MQL4Log] 前処理を実行します。
    public: void Before()
    {
        // ログファイルのローテーションを実施
        RotateLogFile();
    }

    //--- [MQL4Log] 後処理を実行します。
    public: void After()
    {
    }

    //--- [MQL4Log] 致命的なエラーログを出力します。
    public: void Fatal(string message)
    {
        // ログ出力
        WriteLog(LEVEL_FALAL, message);
    
        // 画面表示
        Common.ShowMessage(message);
    
        // EA停止
        ExpertRemove();
    }
    
    //--- [MQL4Log] エラーログを出力します。
    public: void Error(string message)
    {
        // ログ出力
        WriteLog(LEVEL_ERROR, message);
    
        // 画面表示
        Common.ShowMessage(message);
    }

    //--- [MQL4Log] 警告ログを出力します。
    public: void Warn(string message)
    {
        // ログ出力
        WriteLog(LEVEL_WARN, message);
    }

    //--- [MQL4Log] 情報ログを出力します。
    public: void Info(string message)
    {
        // ログ出力
        WriteLog(LEVEL_INFO, message);
    }

    //--- [MQL4Log] デバッグログを出力します。
    public: void Debug(string message)
    {
        //--- ログ出力
        WriteLog(LEVEL_DEBUG, message);
    }

    //--- [MQL4Log] トレースログを出力します。
    public: void Trace(string message)
    {
        //--- ログ出力
        WriteLog(LEVEL_TRACE, message);
    }
    
    //--- [MQL4Log] ログファイルを開きます。
    private: void OpenLogFile()
    {
        // バックテストのログを生成しない場合は終了
        if (IsTesting() && !OUTPUT_TESTING) return;
    
        // ログファイル名
        string name = IntegerToString(TimeYear(TimeLocal()), 4, '0') + IntegerToString(TimeMonth(TimeLocal()), 2, '0') + IntegerToString(TimeDay(TimeLocal()), 2, '0') + " " + Symbol() + " " + Common.TimeframeToString(Period()) + ".log";
    
        // 保存フォルダ
        string path = WindowExpertName() + "/";
    
        // ログファイルが存在する場合
        if (FileIsExist(path + name))
        {
            // ログファイルを開く
            LogFileHandle = FileOpen(path + name, FILE_CSV | FILE_READ | FILE_WRITE | FILE_SHARE_READ, '\t');
    
            // ファイルカーソルを末尾に移動
            FileSeek(LogFileHandle, NULL, SEEK_END);
    
            return;
        }
    
        // ログファイルを新規作成
        LogFileHandle = FileOpen(path + name, FILE_CSV | FILE_WRITE | FILE_SHARE_READ, '\t');
    }

    //--- [MQL4Log] ログファイルを閉じます。
    private: void CloseLogFile()
    {
        // バックテストのログを生成しない場合は終了
        if (IsTesting() && !OUTPUT_TESTING) return;
    
        // ファイルハンドルが不正な値の場合は終了
        if (LogFileHandle == INVALID_HANDLE) return;
    
        // ログファイルを閉じる
        FileClose(LogFileHandle);
    }

    //--- [MQL4Log] 前月以前のログファイルを削除します。
    private: void DeleteLogFile()
    {
        // バックテストの場合
        if (IsTesting())
        {
            // 全てのログファイルを削除
            FolderClean(WindowExpertName());
            FolderDelete(WindowExpertName());
            return;
        }
    
        // ログファイル名
        string name = "";
    
        // 保存フォルダからログファイルを全て検索
        long handle = FileFindFirst(WindowExpertName() + "/" + "*.log", name);
    
        // ログファイルを全て処理
        do
        {
            // 現在の年
            string year = IntegerToString(TimeYear(TimeLocal()), 4, '0');
            // 現在の月
            string month = IntegerToString(TimeMonth(TimeLocal()), 2, '0');
    
            // 今月のログファイルの場合は次へ
            if (StringFind(name, year + month) != EMPTY) continue;
    
            // ログファイルを削除
            FileDelete(WindowExpertName() + "/" + name);
        }
        // 次のログファイルを処理
        while (FileFindNext(handle, name));
    
        // ファイルハンドルを閉じる
        FileFindClose(handle);
    }

    //--- [MQL4Log] ログファイルのローテーションを実行します。
    private: void RotateLogFile()
    {
        // バックテストの場合はローテーション無し
        if (IsTesting()) return;
    
        // 前回のローテーション日
        static uint PreviousRotateDay = 0;
    
        // 日が変わっていない場合はローテーション無し
        if (PreviousRotateDay == 0) PreviousRotateDay = TimeDay(TimeLocal());
        if (PreviousRotateDay == TimeDay(TimeLocal())) return;
    
        // ローテーションを実施
        CloseLogFile();
        OpenLogFile();
    
        // ローテーション日を保持
        PreviousRotateDay = TimeDay(TimeLocal());
    }

    //--- [MQL4Log] ログファイルへの書き込みを実行します。
    private: void WriteLog(int level, string message)
    {
        // バックテストのログを生成しない場合は終了
        if (IsTesting() && !OUTPUT_TESTING) return;
    
        // ログの接頭辞
        string prefix = "";
        if (level == LEVEL_FALAL) prefix = "[FATAL] \t";
        if (level == LEVEL_ERROR) prefix = "[ERROR] \t";
        if (level == LEVEL_WARN)  prefix = "[WARN] \t";
        if (level == LEVEL_INFO)  prefix = "[INFO] \t";
        if (level == LEVEL_DEBUG) prefix = "[DEBUG] \t";
        if (level == LEVEL_TRACE) prefix = "[TRACE] \t";
    
        // 標準出力にログを表示
        if (OUTPUT_CONSOLE != LEVEL_NONE && level >= OUTPUT_CONSOLE) Print(prefix + message);

        // ログファイルに出力
        if (OUTPUT_FILE != LEVEL_NONE && level >= OUTPUT_FILE)
        {
            // ファイルハンドルが不正な値の場合は終了
            if (LogFileHandle == INVALID_HANDLE) return;
    
            // ログファイルへ出力
            FileWrite(LogFileHandle, prefix + TimeToString(TimeLocal(), TIME_SECONDS), Symbol() + "," + Common.TimeframeToString(Period()) + ": " + message);
    
            // 強制出力
            FileFlush(LogFileHandle);
    
            // ファイルカーソルを末尾に移動
            FileSeek(LogFileHandle, NULL, SEEK_END);
        }
    }
};
//+----------------------------------------------------------------------------+


//--- Global Variables
MQL4Log* Log;
//+----------------------------------------------------------------------------+


//--- Conditional Compilation (#ifdef, #ifndef, #else, #endif)
#ifndef MQL4
#include <stdlib.mqh>
#include "MQL4Log.mqh"
#endif 
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| MQL4Dependency class                                                       |
//+----------------------------------------------------------------------------+
class MQL4Dependency
{
    //--- [MQL4Dependency] インジケーター種別
    struct MQLIndicatorMode
    {
        uint number;
        double value;
    };
    
    //--- [MQL4Dependency] インジケーター
    struct MQLIndicator
    {
        string name;
        uint shift;
        MQLIndicatorMode modes[];
    };

    //--- [MQL4Dependency] インジケーター
    private: MQLIndicator indicators[];


    //--- [MQL4Dependency] クラスの初期化処理を実行します。
    public: MQL4Dependency()
    {
        // メンバ変数の初期化
    }

    //--- [MQL4Dependency] クラスの終了処理を実行します。
    public: ~MQL4Dependency()
    {
    }
    
    //--- [MQL4Dependency] インジケーターの数を取得します。
    public: int GetIndicatorsCount()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
   
        // インジケーターの数を返却
        return ArraySize(indicators);
    }
    
    //--- [MQL4Dependency] インジケーターの値を取得します。
    public: double GetIndicator(string name, uint mode, uint shift)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // インジケーターを全て処理
        for (int ind_index = 0; ind_index < ArraySize(indicators); ind_index++)
        {
            // インジケーターが異なる場合は次へ
            if (indicators[ind_index].name != name) continue;
            if (indicators[ind_index].shift != shift) continue;
    
            // インジケーターのプロパティを全て処理
            for (int mode_index = 0; mode_index < ArraySize(indicators[ind_index].modes); mode_index++)
            {
                // インジケーターのプロパティ番号が異なる場合は次へ
                if (indicators[ind_index].modes[mode_index].number != mode) continue;
    
                // インジケーターの値を返却
                return indicators[ind_index].modes[mode_index].value;
            }
        }
    
        // ログ出力
        Log.Warn("indicator value not found [" + name + "(" + IntegerToString(mode) + "," + IntegerToString(shift) + ")]");
    
        // 終了
        return EMPTY;
    }
    
    //--- [MQL4Dependency] インジケーターの値を更新します。
    public: void UpdateIndicator(string name, uint mode, uint shift, double value)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
   
        // インジケーターを全て処理
        for (int ind_index = 0; ind_index < ArraySize(indicators); ind_index++)
        {
            // インジケーターが異なる場合は次へ
            if (indicators[ind_index].name != name) continue;
            if (indicators[ind_index].shift != shift) continue;
    
            // インジケーターのプロパティを全て処理
            for (int mode_index = 0; mode_index < ArraySize(indicators[ind_index].modes); mode_index++)
            {
                // インジケーターのプロパティ番号が異なる場合は次へ
                if (indicators[ind_index].modes[mode_index].number != mode) continue;
    
                // インジケーターの値を更新
                indicators[ind_index].modes[mode_index].value = value;
    
                // 終了
                return;
            }
    
            // インジケーターのプロパティを新規追加
            ArrayResize(indicators[ind_index].modes, ArraySize(indicators[ind_index].modes) + 1);
            indicators[ind_index].modes[ArraySize(indicators[ind_index].modes) - 1].number = mode;
            indicators[ind_index].modes[ArraySize(indicators[ind_index].modes) - 1].value = value;
    
            // 終了
            return;
        }
    
        // インジケーターを新規追加
        ArrayResize(indicators, ArraySize(indicators) + 1);
        indicators[ArraySize(indicators) - 1].name = name;
        indicators[ArraySize(indicators) - 1].shift = shift;
    
        // インジケーターのプロパティを新規追加
        ArrayResize(indicators[ArraySize(indicators) - 1].modes, ArraySize(indicators[ArraySize(indicators) - 1].modes) + 1);
        indicators[ArraySize(indicators) - 1].modes[ArraySize(indicators[ArraySize(indicators) - 1].modes) - 1].number = mode;
        indicators[ArraySize(indicators) - 1].modes[ArraySize(indicators[ArraySize(indicators) - 1].modes) - 1].value = value;
    }

    //--- [MQL4Dependency] インジケーター情報のログ出力用文字列を取得します。
    public: string GetIndicatorLog(int target)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // ログ出力用文字列
        string message = indicators[target].name + "_" + IntegerToString(indicators[target].shift) + ": ";
    
        // インジケーターのプロパティを全て処理
        for (int index = 0; index < ArraySize(indicators[target].modes); index++)
        {
            // 区切り文字を追加
            if (index != 0) StringAdd(message, ",");
    
            // ログ出力用文字列に追加
            StringAdd(message, ValueToString(indicators[target].modes[index].value));
        }
    
        // ログ出力用文字列を返却
        return message;
    }

    //--- [MQL4Dependency] カスタムインジケーターが存在するかどうか確認します。
    public: void CheckCustomIndicator(string name)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // エラー内容を初期化
        ResetLastError();
    
        // カスタムインジケーターを呼び出し
        iCustom(Symbol(), Period(), name, 0, SHIFT_CURRENT);
    
        // エラー内容を取得
        int error = GetLastError();
    
        // エラーが発生していない場合は終了
        if (error == ERR_NO_ERROR) return;
    
        // ログ出力
        Common.ShowMessage(ErrorDescription(error) + " [" + name + ".ex4]");
        Log.Fatal(ErrorDescription(error) + " [" + name + ".ex4]");
    }
    
    //--- [MQL4Dependency] インジケーターの値を文字列に変換します。
    private: string ValueToString(double value)
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        if (value == NULL) return "null";
        if (value == EMPTY) return "empty";
        if (value == EMPTY_VALUE) return "empty value";
        return (DoubleToString(value));
    }
};
//+----------------------------------------------------------------------------+


//--- Global Variables
MQL4Dependency* Dependency;
//+----------------------------------------------------------------------------+


//--- Program Properties
#property strict

//+----------------------------------------------------------------------------+


//--- Conditional Compilation (#ifdef, #ifndef, #else, #endif)
#ifndef MQL4
#include "MQL4Framework.mqh"
#endif 
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| MQL4Indicator class                                                        |
//+----------------------------------------------------------------------------+
class MQL4Indicator : public MQL4Framework
{
    //--- [MQL4Indicator] クラスの初期化処理を実行します。
    public: MQL4Indicator() : MQL4Framework()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // エラーメッセージを非表示
        Common.HideMessage();
    }
    
    //--- [MQL4Indicator] クラスの終了処理を実行します。
    public: ~MQL4Indicator()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    }

    //--- [MQL4Indicator] 初期化処理を実行します。
    protected: int Init()
    {
        // バッファの初期化処理を実行
        InitializeBuffer();
    
        // ステータスを返却
        return INIT_SUCCEEDED;
    }

    //--- [MQL4Indicator] バッファの初期化処理を実行します。
    protected: virtual void InitializeBuffer()
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
    
        // オーバーライド
        
        return;
    }
    
    //--- [MQL4Indicator] インジケーター計算処理を実行します。
    protected: virtual int Calculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[], const long& volume[], const int& spread[])
    {
        // トレースログを出力
        Log.Trace(__FUNCSIG__);
        
        // 計算済みローソク足の本数を返却
        return (rates_total);
    }
};
//+----------------------------------------------------------------------------+

#property indicator_separate_window
#property indicator_buffers 27//(表示用＋計算用のバッファの数)
//--- Global Variables
//+----------------------------------------------------------------------------+
input   string              SeparateRSI = "";                           // ▼ ma設定
input   int                 MAPeriod1 = 2;
input   int                 MAPeriod2 = 4;
input   int                 MAPeriod3 = 6;
input   int                 MAPeriod4 = 12;
input   int                 MAPeriod5 = 18;
input   int                 MAPeriod6 = 24;
input   int                 MAPeriod7 = 32;
input   int                 MAPeriod8 = 48;

input   double              BBPeriod = 2;
input   int                 sum = 200; //useとeurの差
input   int                 sumAngle = 60;           //角度の合計
input   int                 okCount = 10;                //条件にかぶってるものの数
input   int                 continueNum = 20;//〇連続で出れば矢印出す
input   string              SeparateArrow = "";                         // ▼ 矢印設定
input   string              SeparateArrowColor = "";                    // 色
input   color               ArrowColorBuy = clrAqua;                    // ┃ ┣ 買
input   color               ArrowColorSell = clrMagenta;                // ┃ ┗ 売
input   uint                ArrowSize = 3;                              // ┗ 大きさ


input   string              SeparateAlert = "";                         // ▼ アラート設定
input   bool                UseAlert = true;                            // ┗ ON/OFF

input   string              SeparateSendMail = "";                      // ▼ メール設定
input   bool                UseSendMail = true;                         // ┗ ON/OFF
//+----------------------------------------------------------------------------+

//--- Global Files
double  VolumeUSD1[];
double  VolumeEUD1[];
double  VolumeUSD2[];
double  VolumeEUD2[];
double  VolumeUSD3[];
double  VolumeEUD3[];
double  VolumeUSD4[];
double  VolumeEUD4[];
double  VolumeUSD5[];
double  VolumeEUD5[];
double  VolumeUSD6[];
double  VolumeEUD6[];
double  VolumeUSD7[];
double  VolumeEUD7[];
double  VolumeUSD8[];
double  VolumeEUD8[];
double  winLose[];
double  UpBuffer[];
double  CenterBuffer[];
double  DownBuffer[];
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| Indicator class                                                            |
//+----------------------------------------------------------------------------+
class Indicator : public MQL4Indicator
{
    //--- [MQL4Indicator] バッファの初期化処理を実行します。
    protected: void InitializeBuffer()
    {
        DeleteAllObjects();
        IndicatorBuffers(27);
        Comment("赤がEUR");
   
        //↓表示用のバッファ
        
        SetIndexBuffer(0,VolumeUSD1);
        SetIndexBuffer(1,VolumeEUD1);
        SetIndexLabel(0, "USD");
        SetIndexLabel(1, "EUR");
        SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrAliceBlue);
        SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1,clrRed);
        SetIndexBuffer(2, winLose);
        SetIndexLabel(2, NULL);
        SetIndexStyle(2, DRAW_NONE);
        
        SetIndexBuffer(6,VolumeUSD2);
        SetIndexBuffer(7,VolumeEUD2);
        SetIndexLabel(6, "USD");
        SetIndexLabel(7, "EUR");
        SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 2, clrAliceBlue);
        SetIndexStyle(7, DRAW_LINE, STYLE_SOLID, 2,clrRed);
        SetIndexBuffer(8, winLose);
        SetIndexLabel(8, NULL);
        SetIndexStyle(8, DRAW_NONE);
        
        SetIndexBuffer(9,VolumeUSD3);
        SetIndexBuffer(10,VolumeEUD3);
        SetIndexLabel(9, "USD");
        SetIndexLabel(10, "EUR");
        SetIndexStyle(9, DRAW_LINE, STYLE_SOLID, 3, clrAliceBlue);
        SetIndexStyle(10, DRAW_LINE, STYLE_SOLID, 3,clrRed);
        SetIndexBuffer(11, winLose);
        SetIndexLabel(11, NULL);
        SetIndexStyle(11, DRAW_NONE);
        
        SetIndexBuffer(12,VolumeUSD4);
        SetIndexBuffer(13,VolumeEUD4);
        SetIndexLabel(12, "USD");
        SetIndexLabel(13, "EUR");
        SetIndexStyle(12, DRAW_LINE, STYLE_SOLID, 4, clrAliceBlue);
        SetIndexStyle(13, DRAW_LINE, STYLE_SOLID, 4,clrRed);
        SetIndexBuffer(14, winLose);
        SetIndexLabel(14, NULL);
        SetIndexStyle(14, DRAW_NONE);
        
        SetIndexBuffer(15,VolumeUSD5);
        SetIndexBuffer(16,VolumeEUD5);
        SetIndexLabel(15, "USD");
        SetIndexLabel(16, "EUR");
        SetIndexStyle(15, DRAW_LINE, STYLE_SOLID, 5, clrAliceBlue);
        SetIndexStyle(16, DRAW_LINE, STYLE_SOLID, 5,clrRed);
        SetIndexBuffer(17, winLose);
        SetIndexLabel(17, NULL);
        SetIndexStyle(17, DRAW_NONE);
        
        SetIndexBuffer(18,VolumeUSD6);
        SetIndexBuffer(19,VolumeEUD6);
        SetIndexLabel(18, "USD");
        SetIndexLabel(19, "EUR");
        SetIndexStyle(18, DRAW_LINE, STYLE_SOLID, 6, clrAliceBlue);
        SetIndexStyle(19, DRAW_LINE, STYLE_SOLID, 6,clrRed);
        SetIndexBuffer(20, winLose);
        SetIndexLabel(20, NULL);
        SetIndexStyle(20, DRAW_NONE);
        
        SetIndexBuffer(21,VolumeUSD7);
        SetIndexBuffer(22,VolumeEUD7);
        SetIndexLabel(21, "USD");
        SetIndexLabel(22, "EUR");
        SetIndexStyle(21, DRAW_LINE, STYLE_SOLID, 7, clrAliceBlue);
        SetIndexStyle(22, DRAW_LINE, STYLE_SOLID, 7,clrRed);
        SetIndexBuffer(23, winLose);
        SetIndexLabel(23, NULL);
        SetIndexStyle(23, DRAW_NONE);
        
        SetIndexBuffer(24,VolumeUSD8);
        SetIndexBuffer(25,VolumeEUD8);
        SetIndexLabel(24, "USD");
        SetIndexLabel(25, "EUR");
        SetIndexStyle(24, DRAW_LINE, STYLE_SOLID, 8, clrAliceBlue);
        SetIndexStyle(25, DRAW_LINE, STYLE_SOLID, 8,clrRed);
        SetIndexBuffer(26, winLose);
        SetIndexLabel(26, NULL);
        SetIndexStyle(26, DRAW_NONE);
        
        SetIndexBuffer(3, UpBuffer);
        SetIndexBuffer(4, CenterBuffer);
        SetIndexBuffer(5, DownBuffer);
        SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1, clrBlue);
        SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1, clrBlue);
        SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 1, clrBlue);
    }
    
    //--- [MQL4Indicator] インジケーター計算処理を実行します。
    protected: int Calculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[], const long& volume[], const int& spread[])
    {
       
        // 未計算の足を全て処理
         for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
            VolumeUSD1[index] = CheckUSD1(index);
            VolumeEUD1[index] = CheckEUD1(index);
            
            VolumeUSD2[index] = CheckUSD2(index);
            VolumeEUD2[index] = CheckEUD2(index);
            
            VolumeUSD3[index] = CheckUSD3(index);
            VolumeEUD3[index] = CheckEUD3(index);
            
            VolumeUSD4[index] = CheckUSD4(index);
            VolumeEUD4[index] = CheckEUD4(index);
            
            VolumeUSD5[index] = CheckUSD5(index);
            VolumeEUD5[index] = CheckEUD5(index);
            
            VolumeUSD6[index] = CheckUSD6(index);
            VolumeEUD6[index] = CheckEUD6(index);
            
            VolumeUSD7[index] = CheckUSD7(index);
            VolumeEUD7[index] = CheckEUD7(index);
            
            VolumeUSD8[index] = CheckUSD8(index);
            VolumeEUD8[index] = CheckEUD8(index);
            
            //string timea = "OBJ I0130 a" + TimeToString(Time[index]);
            //if(TimeHour(Time[index]) == 0 )Common.CreateVLine(timea,Time[index], clrWheat, 1,STYLE_SOLID, false, true);
        }
         for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
            string objname_buy = OBJNAME_BUY + TimeToString(Time[index]);
            string objname_sell = OBJNAME_SELL + TimeToString(Time[index]);
        
            ObjectDelete(ChartID(), objname_buy);
            ObjectDelete(ChartID(), objname_sell);
            
            /*
            if(index < 3 || index != Bars - IndicatorCounted() - 1)
            {
               if(VolumeUSD[index + 1] > VolumeEUD[index + 1] && VolumeUSD[index] <= VolumeEUD[index])winLose[index] = 1;
               else if(VolumeUSD[index + 1] < VolumeEUD[index + 1] && VolumeUSD[index] >= VolumeEUD[index])winLose[index] = 2;
               else winLose[index] = 0;
            }
            */
            
            
            if (CheckBuy(index) == 8)
            {
                Common.CreateArrow(objname_buy, 233, ArrowColorBuy, 5, Time[index], Low[index], ANCHOR_TOP);
            }
            
            if (CheckSell(index) == 8)
            {
                Common.CreateArrow(objname_sell, 234, ArrowColorSell, 5, Time[index], High[index], ANCHOR_BOTTOM);
            }
            
            
        }
        
        
        static datetime PreviousAlertAndMailTime = NULL;
        
        if (PreviousAlertAndMailTime != Time[SHIFT_CURRENT])
        {
            if (ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[SHIFT_CURRENT])) != EMPTY)
            {
                string message = Symbol() + "," + Common.TimeframeToString(Period()) + ": " + WindowExpertName() + " is Buy.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
            }
            
            if (ObjectFind(ChartID(), OBJNAME_SELL + TimeToString(Time[SHIFT_CURRENT])) != EMPTY)
            {
                string message = Symbol() + "," + Common.TimeframeToString(Period()) + ": " + WindowExpertName() + " is Sell.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
            }
        }
        
        // 計算済みの足の本数を返却
        return rates_total - 1;
    }
    private: double getAngle(string Pare ,int period ,int icount)
    {
      double value1 =iMA(Pare, Period(), period, NULL, MODE_EMA, PRICE_CLOSE, icount + period);
      double value2 =iMA(Pare, Period(), period, NULL, MODE_EMA, PRICE_CLOSE, icount);
      return Common.Angle(value2 ,value1 ,period);//符号はvalue2 - value1
    }
    private: bool timeCheck(int icount)
    {
    //日本時間の6時から14時のみ取引
      if(TimeHour(Time[icount]) == 0)return true;
      if(TimeHour(Time[icount]) == 1)return true;
      if(TimeHour(Time[icount]) == 2)return true;
      if(TimeHour(Time[icount]) == 3)return true;
      if(TimeHour(Time[icount]) == 4)return true;
      if(TimeHour(Time[icount]) == 5)return true;
      if(TimeHour(Time[icount]) == 6)return true;
      if(TimeHour(Time[icount]) == 7)return true;
      if(TimeHour(Time[icount]) == 8)return true;
      return false;
    }
    
    
    private: int CheckBuy(int icount)
    {   
        if(ArrayRange(VolumeEUD1,0) < continueNum + icount + 10) return false;
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 5)return false;
        
        //USDが弱いとき
        //if(VolumeUSD[icount + continueNum] < VolumeEUD[icount + continueNum])return false;
        
        //----------------------------------------------------------------------------------------
        string time = "OBJ I0130 " + TimeToString(Time[icount]);
        
        int count = 0;
        

        if(VolumeUSD1[icount + 1] < VolumeEUD1[icount + 1])count++;
        if(VolumeUSD2[icount + 1] < VolumeEUD2[icount + 1])count++;
        if(VolumeUSD3[icount + 1] < VolumeEUD3[icount + 1])count++;
        if(VolumeUSD4[icount + 1] < VolumeEUD4[icount + 1])count++;
        if(VolumeUSD5[icount + 1] < VolumeEUD5[icount + 1])count++;
        if(VolumeUSD6[icount + 1] < VolumeEUD6[icount + 1])count++;
        if(VolumeUSD7[icount + 1] < VolumeEUD7[icount + 1])count++;
        if(VolumeUSD8[icount + 1] < VolumeEUD8[icount + 1])count++;
   
        
        return count;
        
       
    }
    
    private: int CheckSell(int icount)
    {
    //USDが強いとき
        
        if(ArrayRange(VolumeEUD1,0) < continueNum + icount + 10) return false;
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 5)return false;
        
        
        //if(CheckUSD(icount + continueNum) > CheckEUD(icount + continueNum))return false;
        //--------------------------------------------------------------------------------------
        string time = "OBJ I0130 " + TimeToString(Time[icount]);
        
        //if(MathAbs(VolumeUSD[icount] - VolumeEUD[icount]) < sum)return false;
        int count = 0;
        
        
        if(VolumeUSD1[icount + 1] > VolumeEUD1[icount + 1])count++;
        if(VolumeUSD2[icount + 1] > VolumeEUD2[icount + 1])count++;
        if(VolumeUSD3[icount + 1] > VolumeEUD3[icount + 1])count++;
        if(VolumeUSD4[icount + 1] > VolumeEUD4[icount + 1])count++;
        if(VolumeUSD5[icount + 1] > VolumeEUD5[icount + 1])count++;
        if(VolumeUSD6[icount + 1] > VolumeEUD6[icount + 1])count++;
        if(VolumeUSD7[icount + 1] > VolumeEUD7[icount + 1])count++;
        if(VolumeUSD8[icount + 1] > VolumeEUD8[icount + 1])count++;

        
        return count;
        
        //------------------------------------------------------------------------------------
        /*
        for(int i = 1 ;i < continueNum ;i++)
        {
            if(winLose[icount + i] == 1 )return false;
            if(winLose[icount + i] == 2 )
            {
               if(MathAbs(VolumeUSD[icount] - VolumeEUD[icount]) > sum && VolumeUSD[icount] > VolumeEUD[icount]
               && iBands(Symbol(),0,21,1.5,0,PRICE_CLOSE,MODE_UPPER,icount) < High[icount]
               )return true;
               else return false;
            }
            //if(CheckUSD(icount + i) <= CheckEUD(icount + i))return false;
        }
        //if(MathAbs(CheckUSD(icount) - CheckEUD(icount)) < sum)return false;
        return false;
        */
        //---------------------------------------------------------------------------------------------
      
    }
    
     
    private: double CheckUSD1(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
        i = i - getAngle("USDCHF",MAPeriod1,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod1,icount);
        i = i - getAngle("USDCAD",MAPeriod1,icount);
        i = i + getAngle("GBPUSD",MAPeriod1,icount); 
        i = i + getAngle("EURUSD",MAPeriod1,icount); 
        i = i + getAngle("AUDUSD",MAPeriod1,icount); 
        i = i + getAngle("NZDUSD",MAPeriod1,icount); 
        
        
        
       
        return i;
        
        
    }
    
    private: double CheckEUD1(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        i = i + getAngle("EURUSD",MAPeriod1,icount);
        i = i + getAngle("EURGBP",MAPeriod1,icount);
        i = i + getAngle("EURAUD",MAPeriod1,icount);
        i = i + getAngle("EURCHF",MAPeriod1,icount);
        i = i + getAngle("EURJPY",MAPeriod1,icount);
        i = i + getAngle("EURNZD",MAPeriod1,icount);
        i = i + getAngle("EURCAD",MAPeriod1,icount);
        
        
        return -i;
        
        
      
    }
    private: double CheckUSD2(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
       
        
        //--------------------------------------------
        i = i - getAngle("USDCHF",MAPeriod2,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod2,icount);
        i = i - getAngle("USDCAD",MAPeriod2,icount);
        i = i + getAngle("GBPUSD",MAPeriod2,icount); 
        i = i + getAngle("EURUSD",MAPeriod2,icount); 
        i = i + getAngle("AUDUSD",MAPeriod2,icount); 
       i = i + getAngle("NZDUSD",MAPeriod2,icount);
       
       
        
       
        return i;
        
        
    }
    
    private: double CheckEUD2(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        
        
        i = i + getAngle("EURUSD",MAPeriod2,icount);
        i = i + getAngle("EURGBP",MAPeriod2,icount);
        i = i + getAngle("EURAUD",MAPeriod2,icount);
        i = i + getAngle("EURCHF",MAPeriod2,icount);
        i = i + getAngle("EURJPY",MAPeriod2,icount);
        i = i + getAngle("EURNZD",MAPeriod2,icount);
        i = i + getAngle("EURCAD",MAPeriod2,icount);
        
       
        return -i;
        
        
      
    }
    private: double CheckUSD3(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
        
       
       i = i - getAngle("USDCHF",MAPeriod3,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod3,icount);
        i = i - getAngle("USDCAD",MAPeriod3,icount);
        i = i + getAngle("GBPUSD",MAPeriod3,icount); 
        i = i + getAngle("EURUSD",MAPeriod3,icount); 
        i = i + getAngle("AUDUSD",MAPeriod3,icount); 
       i = i + getAngle("NZDUSD",MAPeriod3,icount); 

        return i;
        
        
    }
    
    private: double CheckEUD3(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        
        
        i = i + getAngle("EURUSD",MAPeriod3,icount);
        i = i + getAngle("EURGBP",MAPeriod3,icount);
        i = i + getAngle("EURAUD",MAPeriod3,icount);
        i = i + getAngle("EURCHF",MAPeriod3,icount);
        i = i + getAngle("EURJPY",MAPeriod3,icount);
        i = i + getAngle("EURNZD",MAPeriod3,icount);
        i = i + getAngle("EURCAD",MAPeriod3,icount);
        
       
        return -i;
        
        
      
    }
    private: double CheckUSD4(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
        
       i = i - getAngle("USDCHF",MAPeriod4,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod4,icount);
        i = i - getAngle("USDCAD",MAPeriod4,icount);
        i = i + getAngle("GBPUSD",MAPeriod4,icount); 
        i = i + getAngle("EURUSD",MAPeriod4,icount); 
        i = i + getAngle("AUDUSD",MAPeriod4,icount); 
       i = i + getAngle("NZDUSD",MAPeriod4,icount); 
        
       
        return i;
        
        
    }
    
    private: double CheckEUD4(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        i = i + getAngle("EURUSD",MAPeriod4,icount);
        i = i + getAngle("EURGBP",MAPeriod4,icount);
        i = i + getAngle("EURAUD",MAPeriod4,icount);
        i = i + getAngle("EURCHF",MAPeriod4,icount);
        i = i + getAngle("EURJPY",MAPeriod4,icount);
        i = i + getAngle("EURNZD",MAPeriod4,icount);
        i = i + getAngle("EURCAD",MAPeriod4,icount);
        //f( -i < sumAngle)return false;
        return -i;
        
        
      
    }
    
    private: double CheckUSD5(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
        
       i = i - getAngle("USDCHF",MAPeriod5,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod5,icount);
        i = i - getAngle("USDCAD",MAPeriod5,icount);
        i = i + getAngle("GBPUSD",MAPeriod5,icount); 
        i = i + getAngle("EURUSD",MAPeriod5,icount); 
        i = i + getAngle("AUDUSD",MAPeriod5,icount); 
       i = i + getAngle("NZDUSD",MAPeriod5,icount); 
        
       
        return i;
        
        
    }
    
    private: double CheckEUD5(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        i = i + getAngle("EURUSD",MAPeriod5,icount);
        i = i + getAngle("EURGBP",MAPeriod5,icount);
        i = i + getAngle("EURAUD",MAPeriod5,icount);
        i = i + getAngle("EURCHF",MAPeriod5,icount);
        i = i + getAngle("EURJPY",MAPeriod5,icount);
        i = i + getAngle("EURNZD",MAPeriod5,icount);
        i = i + getAngle("EURCAD",MAPeriod5,icount);
        //f( -i < sumAngle)return false;
        return -i;
        
        
      
    }
    
    private: double CheckUSD6(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
        
       i = i - getAngle("USDCHF",MAPeriod6,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod6,icount);
        i = i - getAngle("USDCAD",MAPeriod6,icount);
        i = i + getAngle("GBPUSD",MAPeriod6,icount); 
        i = i + getAngle("EURUSD",MAPeriod6,icount); 
        i = i + getAngle("AUDUSD",MAPeriod6,icount); 
       i = i + getAngle("NZDUSD",MAPeriod6,icount); 
        
       
        return i;
        
        
    }
    
    private: double CheckEUD6(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        i = i + getAngle("EURUSD",MAPeriod6,icount);
        i = i + getAngle("EURGBP",MAPeriod6,icount);
        i = i + getAngle("EURAUD",MAPeriod6,icount);
        i = i + getAngle("EURCHF",MAPeriod6,icount);
        i = i + getAngle("EURJPY",MAPeriod6,icount);
        i = i + getAngle("EURNZD",MAPeriod6,icount);
        i = i + getAngle("EURCAD",MAPeriod6,icount);
        //f( -i < sumAngle)return false;
        return -i;
        
        
      
    }
    
    private: double CheckUSD7(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
        
       i = i - getAngle("USDCHF",MAPeriod7,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod7,icount);
        i = i - getAngle("USDCAD",MAPeriod7,icount);
        i = i + getAngle("GBPUSD",MAPeriod7,icount); 
        i = i + getAngle("EURUSD",MAPeriod7,icount); 
        i = i + getAngle("AUDUSD",MAPeriod7,icount); 
       i = i + getAngle("NZDUSD",MAPeriod7,icount); 
        
       
        return i;
        
        
    }
    
    private: double CheckEUD7(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        i = i + getAngle("EURUSD",MAPeriod7,icount);
        i = i + getAngle("EURGBP",MAPeriod7,icount);
        i = i + getAngle("EURAUD",MAPeriod7,icount);
        i = i + getAngle("EURCHF",MAPeriod7,icount);
        i = i + getAngle("EURJPY",MAPeriod7,icount);
        i = i + getAngle("EURNZD",MAPeriod7,icount);
        i = i + getAngle("EURCAD",MAPeriod7,icount);
        //f( -i < sumAngle)return false;
        return -i;
        
        
      
    }
    
    private: double CheckUSD8(int icount)
    {   
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_LOWER, icount) < Close[icount])return false;
        //USDが弱いとき
        double i = 0;
        //usd
        //if(countBuySt(icount) < okCount)return false;
        
        
       i = i - getAngle("USDCHF",MAPeriod8,icount);//プラスならグラフが右肩上がり
        i = i - getAngle("USDJPY",MAPeriod8,icount);
        i = i - getAngle("USDCAD",MAPeriod8,icount);
        i = i + getAngle("GBPUSD",MAPeriod8,icount); 
        i = i + getAngle("EURUSD",MAPeriod8,icount); 
        i = i + getAngle("AUDUSD",MAPeriod8,icount); 
       i = i + getAngle("NZDUSD",MAPeriod8,icount); 
        
       
        return i;
        
        
    }
    
    private: double CheckEUD8(int icount)
    {
    //USDが強いとき
        //if(!timeCheck(icount))return false;
        if(Bars <=  icount + 25)return false;
        //if(iBands(NULL,0, 21, 2, 0, PRICE_CLOSE, MODE_UPPER, icount) > Close[icount])return false;
        double i = 0;
        
        
        i = i + getAngle("EURUSD",MAPeriod8,icount);
        i = i + getAngle("EURGBP",MAPeriod8,icount);
        i = i + getAngle("EURAUD",MAPeriod8,icount);
        i = i + getAngle("EURCHF",MAPeriod8,icount);
        i = i + getAngle("EURJPY",MAPeriod8,icount);
        i = i + getAngle("EURNZD",MAPeriod8,icount);
        i = i + getAngle("EURCAD",MAPeriod8,icount);
        //f( -i < sumAngle)return false;
        return -i;
        
        
      
    }
};
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| Expert initialization function                                             |
//+----------------------------------------------------------------------------+
int OnInit()
{
    Fw = new Indicator();
    return Fw.OnInit();
}


//+----------------------------------------------------------------------------+
//| Expert deinitialization function                                           |
//+----------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    Fw.OnDeinit(reason);
    delete Fw;
}
//+----------------------------------------------------------------------------+


//+----------------------------------------------------------------------------+
//| Custom indicator iteration function                                        |
//+----------------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const datetime& time[], const double& open[], const double& high[], const double& low[], const double& close[], const long& tick_volume[], const long& volume[], const int& spread[])
{
    int result = Fw.OnCalculate(rates_total, prev_calculated, time, open, high, low, close, tick_volume, volume, spread);
    return result;
}
//+----------------------------------------------------------------------------+