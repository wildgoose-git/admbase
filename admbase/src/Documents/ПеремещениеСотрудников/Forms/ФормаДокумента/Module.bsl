////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Отвественный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	ДобавитьРеквизитыЭлементыФормы();
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
		
	Если ИмяСобытия ="ЗаписьСправочникаАдресаПроживания" Тогда
		ЗаполнитьТаблицуСвободныхМест();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДетальныеЗаписи

&НаКлиенте
Процедура ДетальныеЗаписиМестоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СформироватьДанныеВыбораМестаВКомнате(ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДетальныеЗаписиМестоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элементы.ДетальныеЗаписи.ТекущиеДанные;
		ТекущиеДанные.Место = ВыбранноеЗначение;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ДетальныеЗаписиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование Тогда
		ТекущиеДанные = Элементы.ДетальныеЗаписи.ТекущиеДанные;
		ТекущиеДанные.Место = Неопределено;
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

//@skip-check module-structure-form-event-regions
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьРеквизитыЭлементыФормы()

	Если Объект.Ссылка.Пустая() Тогда
		Объект.СтоимостьПроживания 	= 60;
		Объект.ДатаЗаселения 		= ТекущаяДатаСеанса();
	КонецЕсли;

	ЗаполнитьТаблицуСвободныхМест();

КонецПроцедуры // ДобавитьРеквизитыЭлементыФормы()

&НаСервере
Процедура ЗаполнитьТаблицуСвободныхМест()
	Выборка = ОбщежитиеФункцииСервер.ПолучитьТаблицуСвободныхМест(Объект.ДатаЗаселения,Объект.Ссылка).Выбрать();
	СвободныеМеста.Очистить();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СвободныеМеста.Добавить(), Выборка);
	КонецЦикла;
КонецПроцедуры // ЗаполнитьТаблицуСвободныхМест()

&НаКлиенте
Процедура СформироватьДанныеВыбораМестаВКомнате(ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ДетальныеЗаписи.ТекущиеДанные;
	СтруктураОтбора = Новый Структура;
	//СтруктураОтбора.Вставить("АдресРегистрации",Объект.АдресРегистрации);
	СтруктураОтбора.Вставить("Комната",ТекущиеДанные.Комната);
	
	НайденныеСтроки = СвободныеМеста.НайтиСтроки(СтруктураОтбора);
	ДанныеВыбора = Новый СписокЗначений();
	Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
		Если МестоНеЗанятоВТекущемДокументе(СтруктураОтбора,СтрокаТаблицы.Место) Тогда
			ДанныеВыбора.Добавить(СтрокаТаблицы.Место);
		КонецЕсли;		
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Функция МестоНеЗанятоВТекущемДокументе(Знач СтруктураОтбора,Место)
	СтруктураОтбора.Вставить("Место",Место);
	Возврат Объект.ДетальныеЗаписи.НайтиСтроки(СтруктураОтбора).Количество() = 0;	
КонецФункции

#КонецОбласти

