// Read-only PSdZData KIS extractor. Requires hsqldb-2.x.jar on the classpath.
// Usage: java -cp hsqldb.jar;. ExtractVehicleRegistry <kiswb-root> <output.dart>
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.sql.*;
import java.util.*;

class ExtractVehicleRegistry {
  static String q(String s) { return s == null ? "" : s.trim().replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\""); }
  static String value(Map<String,String> m, String k) { return m.getOrDefault(k, ""); }
  static Map<String,String> attrs(String raw) {
    Map<String,String> out = new HashMap<>();
    if (raw == null) return out;
    for (String p : raw.split(";")) { int i=p.indexOf('='); if (i>0) out.put(p.substring(0,i), p.substring(i+1)); }
    return out;
  }
  public static void main(String[] a) throws Exception {
    if (a.length != 2) throw new IllegalArgumentException("root and output required");
    Class.forName("org.hsqldb.jdbc.JDBCDriver");
    Set<String> seen = new HashSet<>(); List<String> rows = new ArrayList<>();
    for (String series : new String[]{"F001","F010","F020","F025","F056"}) {
      String db = Paths.get(a[0], series, "KIS").toString();
      try (Connection c=DriverManager.getConnection("jdbc:hsqldb:file:"+db+";readonly=true","SA","")) {
        String sql="SELECT T.NAME,T.BESCHREIBUNG,T.TYPMERKMALE,E.NAME AS EBR FROM KIS.FAHRZEUGTYP T JOIN KIS.EBR E ON E.ID=T.EBR ORDER BY T.NAME";
        try (Statement s=c.createStatement(); ResultSet r=s.executeQuery(sql)) {
          while(r.next()) { String type=r.getString("NAME"); if(!seen.add(series+":"+type)) continue;
            Map<String,String> x=attrs(r.getString("TYPMERKMALE")); String desc=r.getString("BESCHREIBUNG");
            String model=desc==null?"":desc.trim().split(" ")[0]; if(model.equals("-")) model="";
            rows.add("    {'series':'"+q(series)+"','typeKey':'"+q(type)+"','model':'"+q(model)+"','chassis':'"+q(value(x,"EBR").isEmpty()?r.getString("EBR"):value(x,"EBR"))+"','engineFamily':'"+q(value(x,"MBR"))+"','engineVariant':'"+q(value(x,"MOT").isEmpty()?value(x,"AE_MOT"):value(x,"MOT"))+"','market':'"+q(value(x,"MLAND"))+"','steering':'"+q(value(x,"LENK"))+"','bodyStyle':'"+q(value(x,"KFORM"))+"','gearboxHint':'"+q(value(x,"GETR"))+"'},");
          }
        }
      }
    }
    StringBuilder out=new StringBuilder("// GENERATED FILE. Regenerate with tools/extract_vehicle_registry.java.\nconst List<Map<String, String>> psdzVehicleRegistry = [\n");
    rows.sort(String::compareTo); for(String row:rows) out.append(row).append('\n'); out.append("];\n");
    Files.writeString(Paths.get(a[1]), out.toString(), StandardCharsets.UTF_8);
    System.err.println("Wrote "+rows.size()+" registry records");
  }
}
