#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
//@skip-check doc-comment-parameter-section
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	НастройкиОтчета.Описание = НСтр("ru = 'Состав меню.'");

	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СоставМенюПоКатегориям");
	НастройкиВарианта.Описание = НСтр("ru = 'Отражение составов меню в разрезе категорий.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СоставМенюПоВидамСтолов");
	НастройкиВарианта.Описание = НСтр("ru = 'Отражение составов меню в разрезе видов столов.'");

	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СоставМенюОтбор");
	НастройкиВарианта.Описание = НСтр("ru = 'Отражение состава меню.'");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;  

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

//@skip-check module-structure-top-region
#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//@skip-check module-structure-method-in-regions
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.СоставМеню) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.СоставМеню.ПолноеИмя();
		//@skip-check bsl-nstr-string-literal-format
		КомандаОтчет.Представление = НСтр("ru = 'Состав меню';
											|en = 'Menu composition'");
		
		
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "СоставМенюОтбор");
		КомандаОтчет.КлючВарианта = "СоставМенюОтбор";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли