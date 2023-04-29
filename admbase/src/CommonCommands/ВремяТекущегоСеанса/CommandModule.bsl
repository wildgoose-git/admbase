///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительнаяИнформация = ДополнительнаяИнформация();
	ПоказатьПредупреждение(,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Время сеанса: %1
				|На сервере: %2
				|На клиенте: %3
				|
				|Время сеанса - это время сервера,
				|приведенное к часовому поясу:
				|""%4"".'"),
			Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДЛФ=T"),
			Формат(ДополнительнаяИнформация.ДатаСервера, "ДЛФ=T"),
			Формат(ТекущаяДата(), "ДЛФ=T"), // АПК:143 пример вызова ТекущаяДата для определения времени компьютера
			ДополнительнаяИнформация.ПредставлениеЧасовогоПояса));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ДополнительнаяИнформация()
	Результат = Новый Структура;
	Результат.Вставить("ПредставлениеЧасовогоПояса", ПредставлениеЧасовогоПояса(ЧасовойПоясСеанса()));
	Результат.Вставить("ДатаСервера", ТекущаяДата());
	Возврат Результат;
КонецФункции

#КонецОбласти