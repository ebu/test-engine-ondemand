//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vhudson-jaxb-ri-2.1-792 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2012.08.23 at 08:13:31 AM MESZ 
//


package org.iso.mpeg.dash;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyAttribute;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.bind.annotation.XmlType;
import javax.xml.namespace.QName;
import org.w3c.dom.Element;


/**
 * <p>Java class for SegmentBaseType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="SegmentBaseType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Initialization" type="{urn:mpeg:dash:schema:mpd:2011}URLType" minOccurs="0"/>
 *         &lt;element name="RepresentationIndex" type="{urn:mpeg:dash:schema:mpd:2011}URLType" minOccurs="0"/>
 *         &lt;any processContents='lax' namespace='##other' maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="timescale" type="{http://www.w3.org/2001/XMLSchema}unsignedInt" />
 *       &lt;attribute name="presentationTimeOffset" type="{http://www.w3.org/2001/XMLSchema}unsignedLong" />
 *       &lt;attribute name="indexRange" type="{http://www.w3.org/2001/XMLSchema}string" />
 *       &lt;attribute name="indexRangeExact" type="{http://www.w3.org/2001/XMLSchema}boolean" default="false" />
 *       &lt;anyAttribute processContents='lax' namespace='##other'/>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SegmentBaseType", propOrder = {
    "initialization",
    "representationIndex",
    "anies"
})
@XmlSeeAlso({
    MultipleSegmentBaseType.class
})
public class SegmentBaseType {

    @XmlElement(name = "Initialization")
    protected URLType initialization;
    @XmlElement(name = "RepresentationIndex")
    protected URLType representationIndex;
    @XmlAnyElement
    protected List<Element> anies;
    @XmlAttribute
    @XmlSchemaType(name = "unsignedInt")
    protected Long timescale;
    @XmlAttribute
    @XmlSchemaType(name = "unsignedLong")
    protected BigInteger presentationTimeOffset;
    @XmlAttribute
    protected String indexRange;
    @XmlAttribute
    protected Boolean indexRangeExact;
    @XmlAnyAttribute
    private Map<QName, String> otherAttributes = new HashMap<QName, String>();

    /**
     * Gets the value of the initialization property.
     * 
     * @return
     *     possible object is
     *     {@link URLType }
     *     
     */
    public URLType getInitialization() {
        return initialization;
    }

    /**
     * Sets the value of the initialization property.
     * 
     * @param value
     *     allowed object is
     *     {@link URLType }
     *     
     */
    public void setInitialization(URLType value) {
        this.initialization = value;
    }

    /**
     * Gets the value of the representationIndex property.
     * 
     * @return
     *     possible object is
     *     {@link URLType }
     *     
     */
    public URLType getRepresentationIndex() {
        return representationIndex;
    }

    /**
     * Sets the value of the representationIndex property.
     * 
     * @param value
     *     allowed object is
     *     {@link URLType }
     *     
     */
    public void setRepresentationIndex(URLType value) {
        this.representationIndex = value;
    }

    /**
     * Gets the value of the anies property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the anies property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAnies().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Element }
     * 
     * 
     */
    public List<Element> getAnies() {
        if (anies == null) {
            anies = new ArrayList<Element>();
        }
        return this.anies;
    }

    /**
     * Gets the value of the timescale property.
     * 
     * @return
     *     possible object is
     *     {@link Long }
     *     
     */
    public Long getTimescale() {
        return timescale;
    }

    /**
     * Sets the value of the timescale property.
     * 
     * @param value
     *     allowed object is
     *     {@link Long }
     *     
     */
    public void setTimescale(Long value) {
        this.timescale = value;
    }

    /**
     * Gets the value of the presentationTimeOffset property.
     * 
     * @return
     *     possible object is
     *     {@link BigInteger }
     *     
     */
    public BigInteger getPresentationTimeOffset() {
        return presentationTimeOffset;
    }

    /**
     * Sets the value of the presentationTimeOffset property.
     * 
     * @param value
     *     allowed object is
     *     {@link BigInteger }
     *     
     */
    public void setPresentationTimeOffset(BigInteger value) {
        this.presentationTimeOffset = value;
    }

    /**
     * Gets the value of the indexRange property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getIndexRange() {
        return indexRange;
    }

    /**
     * Sets the value of the indexRange property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setIndexRange(String value) {
        this.indexRange = value;
    }

    /**
     * Gets the value of the indexRangeExact property.
     * 
     * @return
     *     possible object is
     *     {@link Boolean }
     *     
     */
    public boolean isIndexRangeExact() {
        if (indexRangeExact == null) {
            return false;
        } else {
            return indexRangeExact;
        }
    }

    /**
     * Sets the value of the indexRangeExact property.
     * 
     * @param value
     *     allowed object is
     *     {@link Boolean }
     *     
     */
    public void setIndexRangeExact(Boolean value) {
        this.indexRangeExact = value;
    }

    /**
     * Gets a map that contains attributes that aren't bound to any typed property on this class.
     * 
     * <p>
     * the map is keyed by the name of the attribute and 
     * the value is the string value of the attribute.
     * 
     * the map returned by this method is live, and you can add new attribute
     * by updating the map directly. Because of this design, there's no setter.
     * 
     * 
     * @return
     *     always non-null
     */
    public Map<QName, String> getOtherAttributes() {
        return otherAttributes;
    }

}
