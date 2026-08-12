
using System.Text.Json;
using System.Text.Json.Serialization;
using System.ComponentModel.DataAnnotations.Schema;
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;
using Newtonsoft.Json;


namespace ParklaysBackend.Models
{
    [Table("parkingslots")]
    public class ParkingSlot
    {
        [Column("id")]
        public long Id { get; set; }   // ✅ bigint → long

        [Column("fid")]
        public long Fid { get; set; }

        [Column("slotnumber")]
        public long SlotNumber { get; set; }

        [Column("lotid")]
        public long LotId { get; set; }   // ✅ integer/bigint → long (safe choice)

        [Column("isfree")]
        public bool IsFree { get; set; }   // ✅ boolean → bool

        [Column("isbike")]
        public bool IsBike { get; set; }   // ✅ boolean → bool

        [Newtonsoft.Json.JsonIgnore]
        [Column("geom")]
        public Geometry? Geom { get; set; }   // ✅ geometry → Geometry
        
       [NotMapped]
public string? GeoJson
{
    get
    {
        if (Geom == null) return null;
        var writer = new GeoJsonWriter();
        return writer.Write(Geom);
    }
}
    }
}
