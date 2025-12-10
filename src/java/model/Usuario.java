package model;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.framework.DataAccessObject;
import java.util.ArrayList;
import model.framework.DataBaseConnections;

public class Usuario extends DataAccessObject {

    private int id;
    private String nome;
    private String email;
    private String senha;

    public Usuario() {
        super("controlefinanceiro.usuario");
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
        addChange("email", email);
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) throws Exception {
        if(senha == null){
            if(this.senha != null){
                this.senha = senha;
                addChange("senha", senha);
            }
        }else{
            if(senha.equals(this.senha) == false){
                String senhaSal = getId() + senha + getId() / 2;
                
                MessageDigest md = MessageDigest.getInstance( "SHA-256" );
                
                String hash = new BigInteger(1, md.digest(senhaSal.getBytes( "UTF-8" ))).toString(16);
                
                this.senha = hash;
                
                addChange("senha", this.senha);
            }
        }
        
    }

    @Override
    protected String getWhereClauseForOneEntity() {
        return "id = " + getId();
    }

    @Override
    protected DataAccessObject fill(ArrayList<Object> data) {
        id = (int) data.get(0);
        nome = (String) data.get(1);
        email = (String) data.get(2);
        senha = (String) data.get(3);
        return this;

    }

    @Override
    protected Usuario copy() {
        Usuario cp = new Usuario();
        cp.setId( getId() );
        cp.setNome( getNome() );
        cp.setEmail(email);
        cp.senha = getSenha();

        return cp;

    }

    @Override
    public String toString() {

        return "Usuario("
                + "Id: " + id
                + ", Nome: " + nome
                + ", email: " + email
                + ", Senha: " + senha
                + ")";

    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Usuario) {
            Usuario aux = (Usuario) obj;
            if (getId() == aux.getId()) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
    
    public boolean loadByEmail() throws Exception {
    String sql = "SELECT * FROM usuario WHERE email = ?";
    
    Connection con = DataBaseConnections.getInstance().getConnection();
    
    PreparedStatement ps = con.prepareStatement(sql);
    
    ps.setString(1, this.email);
    
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        this.id = rs.getInt("id");
        this.nome = rs.getString("nome");
        this.senha = rs.getString("senha");
        this.email = rs.getString("email");
        return true;
    }
    
    return false;
}

    public boolean validarSenha(String senhaDigitada) throws Exception {
    String senhaSal = getId() + senhaDigitada + getId() / 2;

    MessageDigest md = MessageDigest.getInstance("SHA-256");
    String hash = new BigInteger(1, md.digest(senhaSal.getBytes("UTF-8"))).toString(16);
    
    

    return this.senha.equals(hash);
}
    
    public boolean loadById() throws Exception {
    String sql = "SELECT * FROM usuario WHERE id = ?";
    
    Connection con = DataBaseConnections.getInstance().getConnection();
    
    PreparedStatement ps = con.prepareStatement(sql);
    
    ps.setInt(1, this.id);
    
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        this.id = rs.getInt("id");
        this.nome = rs.getString("nome");
        this.senha = rs.getString("senha");
        this.email = rs.getString("email");
        return true;
    }
    
    return false;
}

}
