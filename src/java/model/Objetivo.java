package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.framework.DataAccessObject;
import model.framework.DataBaseConnections;

public class Objetivo extends DataAccessObject {

    private int id;
    private String descricao;
    private float valor;
    private String dataObjetivo; // Renomeado para dataObjetivo
    private int usuarioId;

    public Objetivo() {
        super("controlefinanceiro.objetivo");
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
        addChange("id", id);
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
        addChange("descricao", descricao);
    }

    public float getValor() {
        return valor;
    }

    public void setValor(float valor) {
        this.valor = valor;
        addChange("valor", valor);
    }

    public String getDataObjetivo() {
        return dataObjetivo;
    }

    public void setDataObjetivo(String dataObjetivo) {
        this.dataObjetivo = dataObjetivo;
        addChange("data", dataObjetivo); // No banco continua como 'data'
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
        addChange("usuario_id", usuarioId);
    }

    @Override
    protected String getWhereClauseForOneEntity() {
        return "id = " + getId();
    }

    @Override
    protected DataAccessObject fill(ArrayList<Object> data) {
        id = (int) data.get(0);
        descricao = (String) data.get(1);
        valor = (float) data.get(2);
        // Converter java.sql.Date para String
        Object dataObj = data.get(3);
        if (dataObj instanceof java.sql.Date) {
            java.sql.Date sqlDate = (java.sql.Date) dataObj;
            dataObjetivo = sqlDate.toString(); // Converte para "YYYY-MM-DD"
        } else {
            // Se já for String ou outro tipo
            dataObjetivo = String.valueOf(dataObj);
        }        usuarioId = (int) data.get(4);
        return this;
    }

    @Override
    protected Objetivo copy() {
        Objetivo cp = new Objetivo();
        cp.setId(getId());
        cp.setDescricao(getDescricao());
        cp.setValor(getValor());
        cp.setDataObjetivo(getDataObjetivo());
        cp.setUsuarioId(getUsuarioId());
        return cp;
    }

    @Override
    public String toString() {
        return "Objetivo("
                + "Id: " + id
                + ", Descricao: " + descricao
                + ", Valor: " + valor
                + ", DataObjetivo: " + dataObjetivo
                + ", UsuarioId: " + usuarioId
                + ")";
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Objetivo) {
            Objetivo aux = (Objetivo) obj;
            return getId() == aux.getId();
        }
        return false;
    }

    public ArrayList<Objetivo> loadByUsuarioId(int usuarioId) throws Exception {
        String sql = "SELECT * FROM objetivo WHERE usuario_id = ?";
        Connection con = DataBaseConnections.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, usuarioId);
        ResultSet rs = ps.executeQuery();

        ArrayList<Objetivo> lista = new ArrayList<>();
        while (rs.next()) {
            Objetivo obj = new Objetivo();
            obj.setId(rs.getInt("id"));
            obj.setDescricao(rs.getString("descricao"));
            obj.setValor(rs.getFloat("valor"));
            obj.setDataObjetivo(rs.getString("data")); // Alterado para dataObjetivo
            obj.setUsuarioId(rs.getInt("usuario_id"));
            lista.add(obj);
        }
        return lista;
    }
}