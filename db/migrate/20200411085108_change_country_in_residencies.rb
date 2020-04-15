class ChangeCountryInResidencies < ActiveRecord::Migration[6.0]
  def change
    execute("UPDATE residencies SET country='LV' where country='Latvia'")
    execute("UPDATE residencies SET country='HU' where country='Hungary'")
    execute("UPDATE residencies SET country='KO' where country='Korea (South)'")
    execute("UPDATE residencies SET country='FR' where country='France'")
    execute("UPDATE residencies SET country='SN' where country='Senegal'")
    execute("UPDATE residencies SET country='FI' where country='Finland'")
    execute("UPDATE residencies SET country='AU' where country='Australia'")
    execute("UPDATE residencies SET country='UK' where country='United Kingdom'")
    change_column :residencies, :country, :string, limit: 2
  end
end
