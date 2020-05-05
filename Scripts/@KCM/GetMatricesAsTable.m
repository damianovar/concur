% Retrieves the dependency matrices of the KCM as a struct of tables.
function tTaxonomyTables = GetMatricesAsTable(tKCM)
tTaxonomyTables.deved = tKCM.ToTable(KCM.PMD);
tTaxonomyTables.tla = tKCM.ToTable(KCM.TLA);
tTaxonomyTables.ilo = tKCM.ToTable(KCM.ILO);
end