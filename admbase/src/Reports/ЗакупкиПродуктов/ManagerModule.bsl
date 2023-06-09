#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
//@skip-check module-structure-top-region
#Область ДляВызоваИзДругихПодсистем
	
	// СтандартныеПодсистемы.ВариантыОтчетов
	// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
	//
	//@skip-check module-structure-method-in-regions
//@skip-check doc-comment-parameter-section
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		НастройкиОтчета.Описание = НСтр("ru = 'Закупки у поставщиков.'");
		
		НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЗакупкиУПоставщиков");
		НастройкиВарианта.Описание = НСтр("ru = 'Закупки продуктов.'");

КонецПроцедуры
	
	// Конец СтандартныеПодсистемы.ВариантыОтчетов
#КонецОбласти
	
#КонецЕсли