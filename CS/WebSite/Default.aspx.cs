using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxEditors;
using DevExpress.Web.ASPxGridView;
using DevExpress.Web.ASPxClasses;

public partial class _Default : Page
{
    protected void grid_BeforePerformDataSelect(object sender, EventArgs e)
    {
        Session["ParentID"] = (sender as ASPxGridView).GetMasterRowKeyValue();
    }

    protected void grid_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
    {
        ASPxGridView grid = (ASPxGridView)sender;
        switch (e.Column.FieldName)
        {
            case "Category2ID":
                InitializeCombo(e, "Category1ID", dsCategory2, cmbCombo2_OnCallback, grid);
                break;
            default:
                break;
        }
    }

    private void cmbCombo2_OnCallback(object source, CallbackEventArgsBase e)
    {
        FillCombo(source as ASPxComboBox, e.Parameter, dsCategory2);
    }

    protected void InitializeCombo(ASPxGridViewEditorEventArgs e,
        string parentComboName, SqlDataSource source, CallbackEventHandlerBase callBackHandler, ASPxGridView grid)
    {

        string id = string.Empty;
        if (!grid.IsNewRowEditing)
        {
            object val = grid.GetRowValuesByKeyValue(e.KeyValue, parentComboName);
            id = (val == null || val == DBNull.Value) ? null : val.ToString();
        }
        ASPxComboBox combo = e.Editor as ASPxComboBox;
        if (combo != null)
        {
            // unbind combo
            combo.DataSourceID = null;
            FillCombo(combo, id, source);
            combo.Callback += callBackHandler;
        }
        return;
    }

    protected void FillCombo(ASPxComboBox cmb, string id, SqlDataSource source)
    {
        cmb.Items.Clear();
        // trap null selection
        if (string.IsNullOrEmpty(id)) return;

        // get the values
        source.SelectParameters[0].DefaultValue = id;
        DataView view = (DataView)source.Select(DataSourceSelectArguments.Empty);
        foreach (DataRowView row in view)
        {
            cmb.Items.Add(row[1].ToString(), row[0]);
        }
    }
}