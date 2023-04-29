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
	
	ОповещениеСледующее	= Новый ОписаниеОповещения("ПослеВыбораПользователя", ЭтотОбъект);
	СервисКриптографииDSSКлиент.ВыбратьПользователя(ОповещениеСледующее);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыбораПользователя(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора.Выполнено Тогда
		ПараметрыФормы 			= Новый Структура;
		ПараметрыФормы.Вставить("НастройкиПользователя", РезультатВыбора.НастройкиПользователя);
		ПараметрыФормы.Вставить("ВыбораИзСписка", Ложь);
		
		ОткрытьФорму("Обработка.УправлениеПодключениемDSS.Форма.СписокСертификатов", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
