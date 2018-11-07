<%@ Page Language="vb" AutoEventWireup="true"  CodeFile="Default.aspx.vb" Inherits="_Default" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
	Namespace="DevExpress.Web" TagPrefix="dxwgv" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
	Namespace="DevExpress.Web" TagPrefix="dxe" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
	<title>Custom callback based implementation of cascading comboboxes in an inline mode
	</title>
</head>
<body>
	<form id="form1" runat="server">
	<div>
		<asp:SqlDataSource ID="dsMasterData" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
			SelectCommand="SELECT [ID], [Name], [FullName] FROM [MasterData]"></asp:SqlDataSource>
		<asp:SqlDataSource ID="dsData" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
			SelectCommand="SELECT [ID], [Title], [Description], [Category1ID], [Category2ID], [Category3ID], [Category4ID], [ParentID] FROM [Data] WHERE ([ParentID] = @ParentID)">
			<SelectParameters>
				<asp:SessionParameter Name="ParentID" SessionField="ParentID" Type="Int32" />
			</SelectParameters>
		</asp:SqlDataSource>
		<asp:SqlDataSource ID="dsCategory1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString2 %>"
			SelectCommand="SELECT * FROM [Category1]"></asp:SqlDataSource>
		<asp:SqlDataSource ID="dsCategory2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString3 %>"
			SelectCommand="SELECT ID, Name FROM Category2 WHERE (Category1ID = @Category1ID) ORDER BY Name">
			<SelectParameters>
				<asp:Parameter DefaultValue="0" Name="Category1ID" Type="Int32" />
			</SelectParameters>
		</asp:SqlDataSource>
		<asp:SqlDataSource ID="dsCategory2All" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString3 %>"
			SelectCommand="SELECT ID, Name FROM Category2 ORDER BY Name"></asp:SqlDataSource>

		<script language="javascript" type="text/javascript">
			// <![CDATA[

			function OnCategory1Changed(cmbParent) {
				if (isUpdating)
					return;
				var comboValue = cmbParent.GetSelectedItem().value;
				if (comboValue)
					grid.GetEditor("Category2ID").PerformCallback(comboValue.toString());
			}

			var combo = null;
			var isUpdating = false;
			// ]]>
		</script>

		<br />
		<dxwgv:ASPxGridView ID="gridMaster" runat="server" AutoGenerateColumns="False" DataSourceID="dsMasterData"
			KeyFieldName="ID">
			<Templates>
				<DetailRow>
					<dxwgv:ASPxGridView ID="grid" runat="server" AutoGenerateColumns="False" DataSourceID="dsData"
						KeyFieldName="ID" ClientInstanceName="grid" OnBeforePerformDataSelect="grid_BeforePerformDataSelect"
						OnCellEditorInitialize="grid_CellEditorInitialize">
						<Columns>
                            <dxwgv:GridViewCommandColumn VisibleIndex="0" ShowEditButton="True" ShowNewButton="True" ShowDeleteButton="True"/>
							<dxwgv:GridViewDataTextColumn FieldName="ID" ReadOnly="True" VisibleIndex="1">
								<EditFormSettings Visible="False" />
							</dxwgv:GridViewDataTextColumn>
							<dxwgv:GridViewDataTextColumn FieldName="Title" VisibleIndex="2">
							</dxwgv:GridViewDataTextColumn>
							<dxwgv:GridViewDataTextColumn FieldName="Description" VisibleIndex="3">
							</dxwgv:GridViewDataTextColumn>
							<dxwgv:GridViewDataComboBoxColumn FieldName="Category1ID" VisibleIndex="4">
								<PropertiesComboBox DataSourceID="dsCategory1" TextField="Name" ValueField="ID" ValueType="System.Int32">
									<ClientSideEvents SelectedIndexChanged="function(s, e) { OnCategory1Changed(s); }" />
								</PropertiesComboBox>
							</dxwgv:GridViewDataComboBoxColumn>
							<dxwgv:GridViewDataComboBoxColumn FieldName="Category2ID" VisibleIndex="5">
								<PropertiesComboBox DataSourceID="dsCategory2All" TextField="Name" ValueField="ID"
									ValueType="System.Int32">
								</PropertiesComboBox>
							</dxwgv:GridViewDataComboBoxColumn>
						</Columns>
						<SettingsEditing Mode="Inline" />
						<SettingsDetail IsDetailGrid="true" />
					</dxwgv:ASPxGridView>
				</DetailRow>
			</Templates>
			<Columns>
				<dxwgv:GridViewDataTextColumn FieldName="ID" ReadOnly="True" VisibleIndex="0">
					<EditFormSettings Visible="False" />
				</dxwgv:GridViewDataTextColumn>
				<dxwgv:GridViewDataTextColumn FieldName="Name" VisibleIndex="1">
				</dxwgv:GridViewDataTextColumn>
				<dxwgv:GridViewDataTextColumn FieldName="FullName" VisibleIndex="2">
				</dxwgv:GridViewDataTextColumn>
			</Columns>
			<SettingsDetail ShowDetailRow="true" AllowOnlyOneMasterRowExpanded="true"/>
		</dxwgv:ASPxGridView>
	</div>
	</form>
</body>
</html>