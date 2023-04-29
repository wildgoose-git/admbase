#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	//@skip-check module-structure-top-region
	#Область ДляВызоваИзДругихПодсистем
	
	// СтандартныеПодсистемы.ВариантыОтчетов
	// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
	//
	//@skip-check module-structure-method-in-regions
	//@skip-check doc-comment-parameter-section
	//@skip-check doc-comment-parameter-section
	Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
		МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		НастройкиОтчета.Описание = НСтр("ru = 'Расчеты по сотрудникам'");
		
		НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасчетыПоСотрудникамИтоговыеСуммы");
		НастройкиВарианта.Описание = НСтр("ru = 'Итоговые суммы расчета за месяц.'");
		
		НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасчетыПоСотрудникамВидыСтолов");
		НастройкиВарианта.Описание = НСтр("ru = 'Расчеты по сотрудникам. Виды столов.'");

	КонецПроцедуры
	
	// Конец СтандартныеПодсистемы.ВариантыОтчетов
	#КонецОбласти
	
#КонецЕсли