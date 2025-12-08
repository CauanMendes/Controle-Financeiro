package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.framework.DataAccessObject;
import model.framework.DataBaseConnections;

public class Categoria extends DataAccessObject {

    private int id;
    private String nome;
    private String tipo; // ENUM: "receita", "despesa", etc.
    private int usuarioId; // NOVO CAMPO

    public Categoria() {
        super("controlefinanceiro.categoria");
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
        addChange("id", id);
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
        addChange("nome", nome);
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
        addChange("tipo", tipo);
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
        nome = (String) data.get(1);
        tipo = (String) data.get(2);
        if (data.size() > 3) {
            usuarioId = (int) data.get(3); // Pega usuario_id se existir
        }
        return this;
    }

    @Override
    protected Categoria copy() {
        Categoria cp = new Categoria();
        cp.setId(getId());
        cp.setNome(getNome());
        cp.setTipo(getTipo());
        cp.setUsuarioId(getUsuarioId());
        return cp;
    }

    @Override
    public String toString() {
        return "Categoria("
                + "Id: " + id
                + ", Nome: " + nome
                + ", Tipo: " + tipo
                + ", UsuarioId: " + usuarioId
                + ")";
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Categoria) {
            Categoria aux = (Categoria) obj;
            return getId() == aux.getId();
        }
        return false;
    }

    public ArrayList<Categoria> loadByTipo(String tipo) throws Exception {
        String sql = "SELECT * FROM categoria WHERE tipo = ?";
        Connection con = DataBaseConnections.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, tipo);
        ResultSet rs = ps.executeQuery();

        ArrayList<Categoria> lista = new ArrayList<>();
        while (rs.next()) {
            Categoria cat = new Categoria();
            cat.setId(rs.getInt("id"));
            cat.setNome(rs.getString("nome"));
            cat.setTipo(rs.getString("tipo"));
            cat.setUsuarioId(rs.getInt("usuario_id"));
            lista.add(cat);
        }
        rs.close();
        ps.close();
        con.close();
        return lista;
    }

    public ArrayList<Categoria> loadAll() throws Exception {
        String sql = "SELECT * FROM categoria";
        Connection con = DataBaseConnections.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        ArrayList<Categoria> lista = new ArrayList<>();
        while (rs.next()) {
            Categoria cat = new Categoria();
            cat.setId(rs.getInt("id"));
            cat.setNome(rs.getString("nome"));
            cat.setTipo(rs.getString("tipo"));
            cat.setUsuarioId(rs.getInt("usuario_id"));
            lista.add(cat);
        }
        rs.close();
        ps.close();
        con.close();
        return lista;
    }

    // NOVO MÉTODO: Carrega categorias de um usuário específico
    public ArrayList<Categoria> loadByUsuarioId(int usuarioId) throws Exception {
        String sql = "SELECT * FROM categoria WHERE usuario_id = ? ORDER BY nome";
        Connection con = DataBaseConnections.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, usuarioId);
        ResultSet rs = ps.executeQuery();

        ArrayList<Categoria> lista = new ArrayList<>();
        while (rs.next()) {
            Categoria cat = new Categoria();
            cat.setId(rs.getInt("id"));
            cat.setNome(rs.getString("nome"));
            cat.setTipo(rs.getString("tipo"));
            cat.setUsuarioId(rs.getInt("usuario_id"));
            lista.add(cat);
        }
        
        rs.close();
        ps.close();
        con.close();
        
        return lista;
    }

    // MÉTODO PARA VALIDAR SE O USUÁRIO É DONO DA CATEGORIA
    public boolean pertenceAoUsuario(int usuarioId) throws Exception {
        if (this.id == 0) return false; // Nova categoria, ainda não tem ID
        
        String sql = "SELECT COUNT(*) as total FROM categoria WHERE id = ? AND usuario_id = ?";
        Connection con = DataBaseConnections.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, this.id);
        ps.setInt(2, usuarioId);
        ResultSet rs = ps.executeQuery();
        
        boolean pertence = false;
        if (rs.next()) {
            pertence = rs.getInt("total") > 0;
        }
        
        rs.close();
        ps.close();
        con.close();
        
        return pertence;
    }

    // MÉTODO PARA CARREGAR CATEGORIA POR ID COM VERIFICAÇÃO DE USUÁRIO
    public boolean loadPorIdEUsuario(int id, int usuarioId) throws Exception {
        String sql = "SELECT * FROM categoria WHERE id = ? AND usuario_id = ?";
        Connection con = DataBaseConnections.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, id);
        ps.setInt(2, usuarioId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            this.id = rs.getInt("id");
            this.nome = rs.getString("nome");
            this.tipo = rs.getString("tipo");
            this.usuarioId = rs.getInt("usuario_id");
            
            rs.close();
            ps.close();
            con.close();
            return true;
        }
        
        rs.close();
        ps.close();
        con.close();
        return false;
    }
}