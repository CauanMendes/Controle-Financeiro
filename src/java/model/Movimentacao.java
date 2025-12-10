package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.framework.DataAccessObject;
import model.framework.DataBaseConnections;

public class Movimentacao extends DataAccessObject {

    private int id;
    private String descricao;
    private float valor;
    private String dataMovimentacao; // Alterado para String
    private int usuarioId;
    private int categoriaId;

    public Movimentacao() {
        super("controlefinanceiro.movimentacao");
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

    public String getDataMovimentacao() {
        return dataMovimentacao;
    }

    public void setDataMovimentacao(String dataMovimentacao) {
        this.dataMovimentacao = dataMovimentacao;
        addChange("data", dataMovimentacao); // No banco continua como 'data'
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
        addChange("usuario_id", usuarioId);
    }

    public int getCategoriaId() {
        return categoriaId;
    }

    public void setCategoriaId(int categoriaId) {
        this.categoriaId = categoriaId;
        addChange("categoria_id", categoriaId);
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
        dataMovimentacao = sqlDate.toString(); // "YYYY-MM-DD"
    } else if (dataObj instanceof java.util.Date) {
        java.util.Date utilDate = (java.util.Date) dataObj;
        dataMovimentacao = new java.sql.Date(utilDate.getTime()).toString();
    } else {
        dataMovimentacao = (dataObj != null) ? dataObj.toString() : "";
    }
        usuarioId = (int) data.get(4);
        categoriaId = (int) data.get(5);
        return this;
    }

    @Override
    protected Movimentacao copy() {
        Movimentacao cp = new Movimentacao();
        cp.setId(getId());
        cp.setDescricao(getDescricao());
        cp.setValor(getValor());
        cp.setDataMovimentacao(getDataMovimentacao());
        cp.setUsuarioId(getUsuarioId());
        cp.setCategoriaId(getCategoriaId());
        return cp;
    }

    @Override
    public String toString() {
        return "Movimentacao("
                + "Id: " + id
                + ", Descricao: " + descricao
                + ", Valor: " + valor
                + ", DataMovimentacao: " + dataMovimentacao
                + ", UsuarioId: " + usuarioId
                + ", CategoriaId: " + categoriaId
                + ")";
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Movimentacao) {
            Movimentacao aux = (Movimentacao) obj;
            return getId() == aux.getId();
        }
        return false;
    }

    public ArrayList<Movimentacao> loadByUsuarioId(int usuarioId) throws Exception {
        String sql = "SELECT * FROM movimentacao WHERE usuario_id = ?";
        Connection con = DataBaseConnections.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, usuarioId);
        ResultSet rs = ps.executeQuery();

        ArrayList<Movimentacao> lista = new ArrayList<>();
        while (rs.next()) {
            Movimentacao mov = new Movimentacao();
            mov.setId(rs.getInt("id"));
            mov.setDescricao(rs.getString("descricao"));
            mov.setValor(rs.getFloat("valor"));
            mov.setDataMovimentacao(rs.getString("data")); // Alterado para getString
            mov.setUsuarioId(rs.getInt("usuario_id"));
            mov.setCategoriaId(rs.getInt("categoria_id"));
            lista.add(mov);
        }
        return lista;
    }
    
    public ArrayList<Movimentacao> loadByUsuarioId() throws Exception {
    ArrayList<Movimentacao> lista = new ArrayList<>();
    String sql = "SELECT * FROM movimentacao WHERE usuario_id = ? ORDER BY data_movimentacao DESC";
    
    try (Connection con = DataBaseConnections.getInstance().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setInt(1, this.usuarioId);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Movimentacao mov = new Movimentacao();
                mov.setId(rs.getInt("id"));
                mov.setDescricao(rs.getString("descricao"));
                mov.setValor(rs.getFloat("valor"));
                mov.setDataMovimentacao(rs.getString("data_movimentacao"));
                mov.setUsuarioId(rs.getInt("usuario_id"));
                mov.setCategoriaId(rs.getInt("categoria_id"));
                lista.add(mov);
            }
        }
    }
    
    return lista;
}
}